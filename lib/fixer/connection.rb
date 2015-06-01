# encoding: utf-8

require 'faraday_middleware'
require 'oauth2'

module Fixer
  module Connection

    ALLOWED_OPTIONS = [
      :headers,
      :url,
      :params,
      :request,
      :ssl,
      :proxy
    ].freeze

    def process_options(opts={})
      headers = opts.delete(:headers) || {}
      options = {
        headers: {
          # generic http headers
          'User-Agent' => user_agent,
          'Accept'     => 'application/json;charset=utf-8'
        },
        ssl: { verify: false },
        url: endpoint
      }.merge(opts)
      options[:headers] = options[:headers].merge(headers)

      options.select{|k,v| ALLOWED_OPTIONS.include?(k.to_sym)}
    end

    def connection(opts={})
      @token ||= get_token(opts)
    end

    def connection(options={})
      Faraday::Connection.new(process_options(options)) do |connection|
        connection.request :authorization, 'Bearer', get_token(options).token
        connection.request :json
        connection.response :mashify
        connection.response :logger if options[:debug]
        connection.response :json
        connection.adapter adapter
      end
    end

    def get_token(opts)
      opts = process_options(options)
      opts[:site] = opts.delete(:url)
      @token ||= OAuth2::Client.new(client_id, client_secret, opts) do |connection|
        connection.request :url_encoded
        connection.response :logger if options[:debug]
        connection.adapter adapter
      end.client_credentials.get_token
    end
  end
end
