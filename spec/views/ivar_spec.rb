require 'spec_helper'

describe 'stache/ivar' do
  it "should access an instance variable defined with RSpec #assign in a view method" do
    assign(:user_name, "Thomas")
    render
    rendered.should include "Thomas"
  end

  it "should access an instance variable defined directly in RSpec in a view method" do
    @user_name = "Stefan"
    render
    rendered.should include "Stefan"
  end
end
