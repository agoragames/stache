class StacheController < ApplicationController
  
  def index
    @user = params[:user] || "Matt"
    # index.html.mustache
  end
  
  def with_partials
    @user = params[:user] || "Matt"
    @thing = "Grue"
  end
  
  def with_haml
    @user = params[:user] || "Matt"
    @thing = "Grue"
  end
  
end