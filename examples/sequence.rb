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
    original: 's3://test-fixer/audio.wav',
    job_type: 'audio',
    tasks: [
      sequence: {
        tasks: [
          {
            task_type: 'cut',
            options: { length: 30, fade: 0 }
          },
          {
            task_type: 'transcode',
            options: { format: 'mp3', bit_rate: 64, sample_rate: 44100 },
            result: 's3://test-fixer/audio.mp3'
          }
        ]
      }
    ]
  }
}

new_job = client.jobs.create(job)
puts "new job created: #{new_job.inspect}"
