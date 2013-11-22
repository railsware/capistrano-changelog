require 'git'
require "erb"

require 'nokogiri'

module Git
  class Lib
    def ordered_tags
      command_lines("for-each-ref --sort='*authordate' --format='%(tag)' refs/tags")
    end
    def first_commit
      command("rev-list --max-parents=0 HEAD")
    end
  end
end



module PTLog
  class TagList
    include Enumerable

    def initialize(git, since)
      @list = git.lib.ordered_tags
      @since = since
      @first_commit = git.lib.first_commit
    end

    def each(options = {})
      list_after_item = @list[@list.index(@since), @list.size]

      if block_given?
        list_after_item.reverse.each { |e| yield(e) }
      else
        Enumerator.new(list_after_item.reverse, :each)
      end
    end

    def next_to(name)
      @list[@list.index(name) + 1] || 'HEAD'
    end

    def prev_to(name)
      0 < @list.index(name) && @list[@list.index(name) - 1] or @first_commit
    end
  end

  class ChangeLog
    attr_reader :git, :tags

    def initialize
      @git ||= Git.open(Dir.getwd)
      @start = ENV['PTLOG_SINCE'] || git.lib.ordered_tags[-1]
      @tags = PTLog::TagList.new(@git, @start)
    end

    def log(from, to)
      git.log.between(from, to)
    end

    def stories(from, to)
      output = {}
      log(from, to).each do |commit|
        commit.message.scan(/\#(\d+)/).flatten.each do |num|
          output[num] ||= []
          output[num] << commit.message
        end
      end
      output
    end

    def self.generate
      raise GeneralError, "You have to specify Pivotal token with export PIVOTAL_TOKEN=xyz" unless ENV.has_key?('PIVOTAL_TOKEN')

      changelog = new

      @builder = Nokogiri::HTML::Builder.new(:encoding => 'UTF-8') do |doc|
        doc.body do
          doc.h1 "Change Log @ #{Time.new.utc.strftime('%I:%M%P %D UTC')}"
          changelog.tags.each do |tag|

            doc.h2 do
              doc.text "Release #{tag} "
              doc.span(class: 'date') do
                doc.text changelog.git.gcommit(tag).date.utc.strftime('(%I:%M%P %D UTC)')
              end
            end

            changelog.stories(changelog.tags.prev_to(tag), tag).each do |num, messages|
              doc.div(class: 'story') do
                story = Pivotal::Story.get(num)
                doc.h3 do
                  if story.valid?
                    doc.a(href: story.url) do
                      doc.span(class: 'num') do
                        doc.text num
                      end
                    end
                    doc.span(class: 'name') do
                      doc.text " "
                      doc.text story.name
                    end
                  else
                    doc.span(class: 'num') do
                      doc.text num
                    end
                    doc.span(class: 'name error') do
                      doc.text " "
                      doc.text story.error
                    end
                  end
                end
                doc.ul(class: 'commits') do
                  messages.each do |message|
                    doc.li message
                  end
                end
              end
            end
          end
        end
      end

      @builder.to_html
    end
  end
end
