require 'spec_helper'

module Stache
  module Handlebars
    describe View do
      it "is just a thin wrapper around Handlebars::Context" do
        View.new.should be_a_kind_of(::Handlebars::Context)
      end
    end
  end
end