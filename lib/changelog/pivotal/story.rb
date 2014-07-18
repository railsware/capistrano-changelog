require 'faraday'

module Changelog
  module Pivotal
    class Story
      attr_reader :num

      def initialize(story_id)
        @num = story_id
        @story = Pivotal::API.story(story_id)
        @labels = @story['labels'].map { |label| label['name'] } if @story['labels'].is_a?(Array)
      end

      def invalid?
        @story['kind'] == 'error'
      end

      def valid?
        !invalid?
      end

      def method_missing(meth)
        if @story.has_key?(meth.to_s)
          @story[meth.to_s]
        else
          super
        end
      end

      def self.get(id)
        return @stories[id] if defined?(@stories) and @stories[id]
        @stories ||= {}
        @stories[id] = new(id)
      end
    end
  end
end
