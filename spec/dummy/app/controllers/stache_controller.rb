class StacheController < ApplicationController

  def index
    @user = params[:user] || "Matt"
    # index.html.mustache
  end

  def with_partials
    @user = params[:user] || "Matt"
    @thing = "Grue"
  end

  def with_asset_helpers
    require 'with_asset_helpers'
    # with_asset_helpers.html.mustache
  end

end