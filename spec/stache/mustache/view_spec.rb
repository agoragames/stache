require 'spec_helper'

module Stache
  module Mustache
    describe View do
      it "is just a thin wrapper around Mustache" do
        View.new.should be_a_kind_of(::Mustache)
      end
    end
  end
end