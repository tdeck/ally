class HomeController < ApplicationController
  skip_before_action :require_session!

  def index
  end
end
