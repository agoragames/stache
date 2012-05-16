class HandlebarsController < ApplicationController

  def index
    @user = params[:user] || "Matt"
    # index.html.hbs
  end

  def with_partials
    @user = params[:user] || "Matt"
    @thing = "Grue"
  end

  def with_helpers
    @image = "image.png"
    @some_text = "lowercase"
  end

end