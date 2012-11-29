require 'spec_helper'

describe HandlebarsController do
  render_views

  before do
    Stache.template_base_path = ::Rails.root.join('app', 'views')
  end

  it "can get to index and render a Handlebars" do
    get :index
    assert_response 200

    response.should render_template 'index'
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

  it "correctly uses helpers" do
    get :with_helpers
    assert_response 200

    response.body.should =~ /Here's an image_path=\/assets\/image\.png/
    response.body.should =~ /Here's a capitalized string: Lowercase/
  end

  it "doesn't blow up if it is missing data" do
    get :with_missing_data
    assert_response 200

    response.body.should =~ /I should not \./
  end


end
