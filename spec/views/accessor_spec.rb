require 'spec_helper'

describe 'stache/accessor' do
  it "should pass an instance variable through via an accessor" do
    assign(:user, "Magnus")
    render
    rendered.should include "Magnus"
  end
end
