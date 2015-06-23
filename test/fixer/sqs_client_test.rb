# encoding: utf-8

require 'minitest_helper'

describe Fixer::SqsClient do

  let(:client) { Fixer::SqsClient.new }

  let(:job_params) do
    {
      job: {
        job_type: 'test',
        priority: 1,
        retry_max: 10,
        retry_delay: 300,
        tasks: [
          sequence: {
            tasks: [
              {
                task_type: 'echo',
                label: 'test1',
                options: { foo: 'bar' },
                call_back: 'http://cms.prx.dev/call_back'
              },
              {
                task_type: 'echo',
                label: 'test2',
                options: { bar: 'foo' },
                call_back: 'http://cms.prx.dev/call_back',
                result: 'http://cms.prx.dev/echo.txt'
              }
            ]
          }
        ]
      }
    }
  end

  let(:sqs) do
    queue = Minitest::Mock.new
    queue.expect(:queue_url, 'http://sqs.us-east-1.aws.amazon.com/test_fixer_callback')

    sqs = Minitest::Mock.new
    sqs.expect(:get_queue_url, queue, [Hash])
    sqs.expect(:send_message, true, [Hash])
    sqs
  end

  it 'makes a new client' do
    client.must_be_instance_of Fixer::SqsClient
  end

  it 'creates a complex job' do
    client.sqs = sqs
    j = client.create_job(job_params)
  end
end