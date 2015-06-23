require 'dotenv'
Dotenv.load '.env-fixer_client'

require 'fixer_client'
Fixer.reset!

Fixer.configure do |c|
  c.queue = 'development_fixer_job_create'
end

client = Fixer::SqsClient.new

job = {
  job: {
    original: 's3://test-fixer/audio.wav',
    job_type: 'audio',
    tasks: [
      {
        task_type: 'transcode',
        options: { format: 'mp3', bit_rate: 64, sample_rate: 44100 },
        result: 's3://test-fixer/audio.mp3'
      }
    ]
  }
}

j = client.create_job(job)
