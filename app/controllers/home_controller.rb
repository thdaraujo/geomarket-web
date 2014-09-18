class HomeController < ApplicationController
  before_filter 'check_user', :only => [:index]
  def index
  end
end
