class ProcessNewMeetupEventJob < ApplicationJob
  queue_as :default

  def perform(json_event)

  end
end
