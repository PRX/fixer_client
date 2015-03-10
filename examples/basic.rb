require 'fixer_client'

Fixer.configure do |c|
  c.client_id = 'yourclientid'
  c.client_secret = 'yoursecret'
  c.endpoint = 'http://fixer.prx.dev/api/' # default
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
