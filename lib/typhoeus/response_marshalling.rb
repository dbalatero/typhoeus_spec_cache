require 'yaml'

module Typhoeus
  class Response
    def _dump(depth)
      fields = {
        :code => @code,
        :headers => @headers,
        :body => @body,
        :time => @time,
        :requested_url => @requested_url,
        :requested_http_method => @requested_http_method,
        :start_time => @start_time
      }

      YAML.dump(fields)
    end

    def self._load(string)
      options = YAML.load(string)
      Typhoeus::Response.new(options)
    end
  end
end
