require 'nokogiri'

module PTLog
  class ChangeLog
    def self.generate
      raise GeneralError, "You have to specify Pivotal token with export PIVOTAL_TOKEN=xyz" unless ENV.has_key?('PIVOTAL_TOKEN')

      changelog = PTLog::Wrappers::ChangeLog.new

      @builder = Nokogiri::HTML::Builder.new(:encoding => 'UTF-8') do |doc|
        doc.body do
          doc.h1 changelog.title

          changelog.releases.each do |release|

            doc.h2 do
              doc.text release.title
              doc.span(class: 'date') do
                doc.text release.date
              end
            end

            release.stories.each do |story|
              doc.div(class: 'story') do
                doc.h3 do
                  if story.valid?
                    doc.a(href: story.url) do
                      doc.span(class: 'num') do
                        doc.text story.num
                      end
                    end
                    doc.span(class: 'name') do
                      doc.text " "
                      doc.text story.name
                    end
                  else
                    doc.span(class: 'num') do
                      doc.text story.num
                    end
                    doc.span(class: 'name error') do
                      doc.text " "
                      doc.text story.error
                    end
                  end
                end

                doc.ul(class: 'commits') do
                  release.commits(story.num).each do |commit|
                    doc.li commit.message
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
