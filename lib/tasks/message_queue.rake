namespace :message_queue do
  desc "Run worker to consume messages from RabbitMQ"
  task :consumer do
    GovukMessageQueueConsumer::Consumer.new(
      queue_name: "cache_clearing_service-#{ENV['QUEUE']}",
      processor: Processor.new,
    ).run
  end
end
