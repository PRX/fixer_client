# -*- encoding: utf-8 -*-

require 'aws-sdk-core'

module Fixer
  class SqsClient

    include Configuration

    attr_reader *Fixer::Configuration.keys

    attr_accessor :current_options

    def create_job(job, opts = {})
      job[:job][:id] ||= SecureRandom.uuid
      job[:job][:client_id] ||= client_id

      sqs_options = options.merge(opts)
      sqs_queue = sqs_options[:queue]
      conn = sqs(sqs_options[:aws])
      queue_url = conn.get_queue_url(queue_name: sqs_queue).queue_url
      conn.send_message(queue_url: queue_url, message_body: job.to_json)
      job
    end

    def sqs(options = nil)
      @sqs ||= Aws::SQS::Client.new(options)
    end

    def sqs=(sqs)
      @sqs = sqs
    end

    class_eval do
      Fixer::Configuration.keys.each do |key|
        define_method "#{key}=" do |arg|
          self.instance_variable_set("@#{key}", arg)
        end
      end
    end

    def initialize(options={}, &block)
      apply_options(options)
      yield(self) if block_given?
    end

    def apply_options(options={})
      self.current_options ||= ActiveSupport::HashWithIndifferentAccess.new(Fixer.options)
      Configuration.keys.each do |key|
        send("#{key}=", current_options[key])
      end
    end
  end
end
