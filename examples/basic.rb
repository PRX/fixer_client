require 'dotenv'
Dotenv.load '.env-fixer_client'

require 'fixer_client'
Fixer.reset!

Fixer.configure do |c|
  c.client_id = ENV['FIXER_CLIENT_ID']
  c.client_secret = ENV['FIXER_CLIENT_SECRET']
  c.endpoint = 'http://fixer.prx.dev/api/'
end

client = Fixer::Client.new

job = {
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

j = client.jobs.create(job)
