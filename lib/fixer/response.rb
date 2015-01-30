# -*- encoding: utf-8 -*-

module Fixer
  class Response
    attr_accessor :raw, :request

    def initialize(response, request={})
      @raw     = response
      @request = request

      check_for_error(response)
    end

    def check_for_error(response)
      status_code_type = response.status.to_s[0]
      case status_code_type
      when "2"
        # puts "all is well, status: #{response.status}"
      when "4", "5"
        raise "Whoops, error back from Fixer: #{response.status}"
      else
        raise "Unrecognized status code: #{response.status}"
      end
    end

    def body
      self.raw.body
    end

    def object
      body
    end

    def [](key)
      if self.object.is_a?(Array) || self.object.is_a?(Hash)
        self.object[key]
      else
        self.object.send(:"#{key}")
      end
    end

    def has_key?(key)
      self.object.is_a?(Hash) && self.object.has_key?(key)
    end

    # Coerce any method calls for body attributes
    #
    def method_missing(method_name, *args, &block)
      if self.has_key?(method_name.to_s)
        self.[](method_name, &block)
      elsif self.body.respond_to?(method_name)
        self.body.send(method_name, *args, &block)
      elsif self.request[:api].respond_to?(method_name)
        self.request[:api].send(method_name, *args, &block)
      else
        super
      end
    end

  end
end
