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

    response.body.should =~ /Here's an image_path=\/assets\/image\.png/
    response.body.should =~ /link href="\/assets\/test\.css"/
  end

  it "uses a layout" do
    get :with_layout
    assert_response 200

    response.body.should == "Wrap\nThis is wrapped in a layout\n\nEndWrap\n"
  end

  it "can get render a mustache with rails helpers", :type => :stache do
    get :helper
    assert_response 200

    response.should render_template 'helper'               # view
    response.body.should == "/stache\n"
  end
end
