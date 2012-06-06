class StacheController < ApplicationController
  layout false

  def index
  end

  def with_partials
    @user = params[:user] || "Matt"
    @thing = "Grue"
  end

  def with_asset_helpers
    require 'with_asset_helpers'
    # with_asset_helpers.html.mustache
  end

  def with_layout

  end

end
