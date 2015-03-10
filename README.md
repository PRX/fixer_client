# FixerClient

Client lib for the fixer application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fixer_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fixer_client

## Usage

You need to configure the client credentials:

```ruby
require 'fixer_client'

# by default it will get credentials from ENV
puts ENV['FIXER_CLIENT_ID'] + " is the id"
puts ENV['FIXER_CLIENT_SECRET'] + " is the secret"

# or set them explicitly

Fixer::Client.configure do |c|
  c.client_id = ''
  c.client_secret = ''
  c.endpoint = 'http://fixer.prx.dev/api/' # default
end
```

Once configured, you can use the client to access jobs and tasks:

```ruby
require 'fixer_client'

client = Fixer::Client.new


# list jobs
js = client.jobs.list

# get a particular job by id
j = client.jobs.get('some-job-id')

# update a job
j = client.jobs.update(j)

# create a job
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

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/fixer_client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
