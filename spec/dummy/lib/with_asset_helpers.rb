class Stache::WithAssetHelpers < Stache::View

  def my_image
    @my_image ||= image_path("image.png")
  end

end