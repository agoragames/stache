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

  def with_wrapper

  end

  def helper
    Stache::ViewContext.current = self.view_context
  end

  def no_format_in_extension

  end

  def no_format_in_extension_with_wrapper

  end

end
