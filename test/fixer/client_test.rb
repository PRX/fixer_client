# encoding: utf-8

require 'minitest_helper'

describe Fixer::Client do

  let(:client) { Fixer::Client.new }

  let(:job) do
    {
      job: {
        job_type: 'test',
        priority: 1,
        retry_max: 10,
        retry_delay: 300,
        tasks: [
          {
            task_type: 'echo',
            label: 'test1',
            options: { foo: 'bar' },
            call_back: 'http://cms.prx.dev/call_back'
          }
        ]
      }
    }
  end

  it 'makes a new client' do
    client.must_be_instance_of Fixer::Client
  end

  # it 'gets a list of jobs' do
  #   stub_request(:post, "http://fixer.prx.dev/oauth/token").
  #     with(:body => {"grant_type"=>"client_credentials"}).
  #     to_return(:status => 200, :body => "", :headers => {})

  #   jobs = client.jobs.list
  # end
end
