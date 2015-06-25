require 'dotenv'
Dotenv.load '.env-fixer_client'

require 'fixer_client'
Fixer.reset!

# you also need AWS configured via ENV vars
# id, secret, and region for aws-adk-core to work
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_REGION
# or they can be config options under the :aws config
# :access_key_id, :secret_access_key, and :region
Fixer.configure do |c|
  c.client_id = ENV['FIXER_CLIENT_ID']
  c.client_secret = ENV['FIXER_CLIENT_SECRET']
  c.queue = 'development_fixer_job_create'
  # c.aws = {
  #   access_key_id: 'AMADEUPKEYNOTREAL',
  #   secret_access_key: '11111111111111111111111',
  #   region: 'us-east-1'
  # }
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

new_job = client.create_job(job)
puts "new job created with id: #{new_job.id}"
