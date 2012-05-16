class Stache::WithAssetHelpers < Stache::Mustache::View

  def my_image
    @my_image ||= image_path("image.png")
  end

  def my_styles
    @my_styles ||= stylesheet_link_tag("test")
  end

end