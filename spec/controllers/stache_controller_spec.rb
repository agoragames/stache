require 'spec_helper'

describe StacheController do
  render_views
  
  it "can get to index and render a Mustache" do
    get :index
    assert_response 200

    response.should render_template 'index'               # view
    response.body.should =~ /Hello, Matt!/
  end
  
  it "correctly renders partials" do
    get :with_partials
    assert_response 200
    
    response.body.should =~ /Grue/
    # puts response.body
  end
  
  
end
