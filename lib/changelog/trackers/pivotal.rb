require 'oj'
require 'faraday'
require 'faraday_middleware'

module CapistranoChangelog
  module Trackers
    class Pivotal

      MATCHER = /\#(\d+)/

      def connection
        @connection ||= Faraday.new 'https://www.pivotaltracker.com/services/v5/' do |faraday|
          faraday.request :json
          faraday.response :json, :content_type => /\bjson$/
          faraday.adapter Faraday.default_adapter
          faraday.headers['X-TrackerToken'] = CapistranoChangelog.pivotal_tracker
          faraday.options[:timeout] = 30
          faraday.options[:open_timeout] = 30
        end
      end

      def export(ids)
        response = connection.post do |opts|
          opts.url 'stories/export'
          opts.headers['Content-Type'] = 'application/json'
          opts.body = Oj.dump({"ids" => ids})
        end

        unless response.status == 200
          raise Trackers::BatchError, response.body.inspect
        else
          CSV.parse(response.body, headers: :first_row, skip_blanks: true).map do |row|
            row.values_at(0, 1)
          end
        end
      end

      def get(uid)
        response = connection.get("stories/#{uid}")

        unless response.status == 200
          raise Trackers::AccessDenied
        else
          response.body.values_at(*%w{ id name })
        end
      rescue Trackers::AccessDenied => e
        [ uid, false ]
      rescue Faraday::TimeoutError => e
        sleep(1) and retry
      end

    end
  end
end
