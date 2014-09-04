require 'spec_helper'

describe StacheController do
  render_views

  before do
    #Stache.template_base_path = ::Rails.root.join('app', 'views')
  end

  it "can get to index and render a Mustache" do
    get :index
    assert_response 200

    response.should render_template 'index'               # view
    response.body.should =~ /Hello, Matt!/
  end

  it "can render using a module wrapper" do
    begin
      Stache.wrapper_module_name = "Wrapper"

      get :with_wrapper
      assert_response 200

      response.should render_template 'with_wrapper'
      response.body.should =~ /Yes/
    ensure
      Stache.wrapper_module_name = nil
    end
  end

  it "correctly renders partials" do
    get :with_partials
    assert_response 200

    response.body.should =~ /Grue/
    # puts response.body
  end

  it "correctly uses the asset helpers" do
    get :with_asset_helpers
    assert_response 200

    response.body.should =~ /Here's an image_path=\/images\/image\.png/
    response.body.should =~ /link href="\/assets\/test\.css"/
  end

  it "uses a layout" do
    get :with_layout
    assert_response 200

    response.body.should == "Wrap\nThis is wrapped in a layout\n\nEndWrap\n"
  end

  it "can get render a mustache with rails helpers", type: :stache do
    get :helper
    assert_response 200

    response.should render_template 'helper'               # view
    response.body.should == "/stache\n"
  end

  it "does not require the format in the extension with view class" do
    get :no_format_in_extension
    assert_response 200

    response.should render_template 'no_format_in_extension'
    response.body.should == "No format"
  end

  it "does not require the format in the extension with view class and wrapper module" do
    begin
      Stache.wrapper_module_name = "Wrapper"

      get :no_format_in_extension_with_wrapper
      assert_response 200

      response.should render_template 'no_format_in_extension_with_wrapper'
      response.body.should == "No format"
    ensure
      Stache.wrapper_module_name = nil
    end
  end

  describe "cache usage" do
    before do
      Stache.template_cache = ActiveSupport::Cache::MemoryStore.new
    end

    it "fills the cache" do
      get :with_partials
      get :with_partials  # Render a second time
      Stache.template_cache.instance_variable_get(:@data).size.should eq(1) # But should only contain one element
    end

    it "uses the cache" do
      get :with_partials

      # Setup fake template
      template = Stache::Mustache::CachedTemplate.new("foo")
      template.compile

      # Get first entry and manipulate it to be the fake template
      key = Stache.template_cache.instance_variable_get(:@data).keys.first
      Stache.template_cache.write(key, template, :raw => true)

      # Now check response if it is the fake template
      get :with_partials
      assert_response 200
      response.body.should == "foo"
    end

    after do
      Stache.template_cache = ActiveSupport::Cache::NullStore.new
    end
  end
end
