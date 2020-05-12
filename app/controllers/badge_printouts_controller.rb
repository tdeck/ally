class BadgePrintoutsController < ApplicationController
  include BadgePrintoutsHelper

  def new
  end

  def create
    inputs = params.require(:badges).select { |b| b[:first].present? }

    if inputs.empty?
      return redirect_back fallback_location: new_badge_printout_path, alert: 'Must enter at least one name'
    end

    @badges = inputs.map do |input| 
      role_class = input.require(:role)
      role = available_roles.find { |r| r.classname == role_class }
      Badge.new(input.require(:first), input[:last], input.require(:pronouns), role)
    end
      
    render layout: false
  end
end
