# -*- encoding: utf-8 -*-

require 'aws-sdk-core'

module Fixer
  class SqsClient
    include Configuration

    attr_accessor *Fixer::Configuration.keys

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

    def sqs(opts = nil)
      @sqs ||= Aws::SQS::Client.new(opts || {})
    end

    def sqs=(sqs)
      @sqs = sqs
    end

    def initialize(options = {})
      apply_options(options)
      yield(self) if block_given?
    end

    def apply_options(options = {})
      current_options = Fixer.options.merge(options).with_indifferent_access
      Fixer::Configuration.keys.each do |key|
        send("#{key}=", current_options[key])
      end
    end
  end
end
