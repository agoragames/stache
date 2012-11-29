require 'spec_helper'

describe Stache::Handlebars::Handler do
  before do
    @template = ActionView::Template.new("{{body}}", "hello handlebars", Stache::Handlebars::Handler, { :virtual_path => "hello_world"})
    @handler = Stache::Handlebars::Handler.new
  end

  describe "#handlebars_class_from_template" do
    it "returns the appropriate handlebars class" do
      class HelloWorld < Stache::Handlebars::View; end
      @handler.handlebars_class_from_template(@template).should == HelloWorld
      Object.send(:remove_const, :HelloWorld)
    end
    it "is clever about folders and such" do
      @template.stub!(:virtual_path).and_return("profiles/index")
      module Profiles; class Index < Stache::Handlebars::View; end; end
      @handler.handlebars_class_from_template(@template).should == Profiles::Index
      Object.send(:remove_const, :Profiles)
    end
    it "retuns Stache::Handlebars::View if it can't find none" do
      @handler.handlebars_class_from_template(@template).should == Stache::Handlebars::View
    end
    it "reraises error if loaded handlebars_class raises a NameError" do
      @template.stub!(:virtual_path).and_return("profiles/index")
      module Profiles; end
      # Emulate autoload behavior so the error gets raised upon const_get
      Profiles.autoload :Index, File.join(File.dirname(__FILE__), "profile_autoload.rb")

      lambda {
        @handler.handlebars_class_from_template(@template)
      }.should raise_error(NameError, "uninitialized constant Profiles::Index::Foo")

      Object.send(:remove_const, :Profiles)
    end
  end

  describe "#handlebars_class_from_template with config module wrapper set" do
    before do
      Stache.wrapper_module_name = "Wrapper"
    end

    it "returns the appropriate handlebars class" do
      module Wrapper; class HelloWorld < ::Stache::Handlebars::View; end; end
      @handler.handlebars_class_from_template(@template).should == Wrapper::HelloWorld
      Object.send(:remove_const, :Wrapper)
    end
    it "is clever about folders and such" do
      @template.stub!(:virtual_path).and_return("profiles/index")
      module Wrapper; module Profiles; class Index < ::Stache::Handlebars::View; end; end; end
      @handler.handlebars_class_from_template(@template).should == Wrapper::Profiles::Index
      Object.send(:remove_const, :Wrapper)
    end

    after do
      Stache.wrapper_module_name = nil
    end
  end
end
