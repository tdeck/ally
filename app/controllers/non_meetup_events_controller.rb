class NonMeetupEventsController < ApplicationController
  def new
    @event = NonMeetupEvent.new
  end

  def create
    NonMeetupEvent.create!(params.require(:non_meetup_event).permit(
      :title,
      :url,
      :start_date,
      :end_date,
      :description_html,
    ))

    redirect_to controller: 'events', action: 'index', notice: 'Created'
  end
end
