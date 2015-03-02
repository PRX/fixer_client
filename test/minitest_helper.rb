# encoding: utf-8

require 'simplecov'
SimpleCov.start

require 'dotenv'
Dotenv.load '.env-fixer_client'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require 'fileutils'
require 'active_support'
require 'webmock/minitest'
require 'hashie/mash'

require 'fixer_client'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

# helper method to create mashified test docs, that look like what comes out of the faraday middleware
def mashify(body)
  case body
  when Hash
    ::Hashie::Mash.new(body)
  when Array
    body.map { |item| parse(item) }
  else
    body
  end
end

def json_fixture(name)
  mashify(JSON.parse(json_file(name)))
end

def json_file(name)
  File.read( File.dirname(__FILE__) + "/fixtures/#{name}.json")
end
