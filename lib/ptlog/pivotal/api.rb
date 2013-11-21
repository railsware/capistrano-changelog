require 'faraday'
require 'faraday_middleware'

module PTLog
  module Pivotal
    class API
      class << self
        def connection
          @connection ||= Faraday.new 'https://www.pivotaltracker.com/services/v5' do |faraday|
            faraday.request :json
            faraday.response :json, :content_type => /\bjson$/
            faraday.adapter Faraday.default_adapter
            faraday.headers['X-TrackerToken'] = ENV['PIVOTAL_TOKEN']
            faraday.options[:timeout] = 30
            faraday.options[:open_timeout] = 30
          end
        end

        def get(uri)
          begin
            response = connection.get(uri)

            raise Pivotal::NetworkError unless response.status == 200

            response.body
          rescue Pivotal::NetworkError, Faraday::Error::TimeoutError => e
            {
              'kind' => 'error',
              'error' => 'Unable to fetch data'
            }
          end
        end

        def story(id)
          get("stories/#{id}")
        end

        def epic(id)
          get("epics/#{id}")
        end
      end
    end
  end
end
