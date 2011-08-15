require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Stache
  describe View do
    it "is just a thin wrapper around Mustache" do
      View.new.should be_a_kind_of(Mustache)
    end
  end
end