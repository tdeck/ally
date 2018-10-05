class NamedUsersController < ApplicationController
  def create
    params.require(:full_name)
    params.require(:meetup_id) # This is the *user's* meetup ID
    return_to_event = params.require(:return_to_event)

    NamedUser.create!(params.permit(:full_name, :meetup_id))

    redirect_to event_path(return_to_event)
  end
end
