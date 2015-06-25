# -*- encoding: utf-8 -*-

module Fixer
  module Configuration

    VALID_OPTIONS_KEYS = [
      :client_id,
      :client_secret,
      :adapter,
      :endpoint,
      :user_agent,
      :aws,
      :queue
    ].freeze

    # Adapters are whatever Faraday supports - I like excon alot, so I'm defaulting it
    DEFAULT_ADAPTER = :excon

    # The api endpoint to get REST
    DEFAULT_ENDPOINT = 'http://fixer.prx.dev/api/'.freeze

    # The value sent in the http header for 'User-Agent' if none is set
    DEFAULT_USER_AGENT = "Fixer Ruby Gem #{Fixer::VERSION}".freeze

    # sqs queue to write messages
    DEFAULT_QUEUE = 'production_fixer_job_create'.freeze

    attr_accessor *VALID_OPTIONS_KEYS

    # Convenience method to allow for global setting of configuration options
    def configure
      yield self
    end

    def self.extended(base)
      base.reset!
    end

    class << self
      def keys
        VALID_OPTIONS_KEYS
      end
    end

    def options
      options = {}
      VALID_OPTIONS_KEYS.each { |k| options[k] = send(k) }
      options
    end

    # Reset configuration options to their defaults
    def reset!
      self.client_id     = ENV['FIXER_CLIENT_ID']
      self.client_secret = ENV['FIXER_CLIENT_SECRET']
      self.adapter       = DEFAULT_ADAPTER
      self.endpoint      = ENV['FIXER_ENDPOINT'] || DEFAULT_ENDPOINT
      self.user_agent    = DEFAULT_USER_AGENT
      self.aws           = nil
      self.queue         = ENV['FIXER_QUEUE'] || DEFAULT_QUEUE
      self
    end
  end
end
