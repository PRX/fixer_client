# encoding: utf-8

require 'minitest_helper'

describe Fixer::Client do

  let(:client) { Fixer::Client.new }

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

  before do
    stub_request(:post, "http://fixer.prx.dev/oauth/token").
      with(:body => {"grant_type"=>"client_credentials"}).
      to_return(
        :status => 200,
        :body => "{\"access_token\":\"4651f8250fb5d21f5dce575894446f003304e2856acad2292daf52a76de5c6e8\",\"token_type\":\"bearer\",\"expires_in\":7200,\"created_at\":#{Time.now.to_i}}",
        :headers => {"Content-Type" => "application/json; charset=utf-8"}
      )
  end

  it 'makes a new client' do
    client.must_be_instance_of Fixer::Client
  end

  it 'gets a list of jobs' do
    stub_request(:get, "http://fixer.prx.dev/api/jobs/").
      with(:headers => {'Accept'=>'application/json;charset=utf-8'}).
      to_return(:status => 200, :body => {}.to_json, :headers => {})

    jobs = client.jobs.list
  end

  it 'creates a complex job' do
    stub_request(:post, "http://fixer.prx.dev/api/jobs/").
      with(:headers => { 'Accept' => 'application/json;charset=utf-8', 'Content-Type' => 'application/json' } ).
      to_return(:status => 200, :body => "", :headers => {})

    j = client.jobs.create(job_params)
  end
end