require 'spec_helper'

describe Stache::Mustache::Handler do
  # ERBHandler = ActionView::Template::Handlers::ERB.new
  # def new_template(body = "<%= hello %>", details = {})
  #   ActionView::Template.new(body, "hello template", ERBHandler, {:virtual_path => "hello"}.merge!(details))
  # end
  before do
    @template = ActionView::Template.new("{{body}}", "hello mustache", Stache::Mustache::Handler, { :virtual_path => "hello_world"})
    @handler = Stache::Mustache::Handler.new
  end

  describe "#mustache_class_from_template" do
    it "returns the appropriate mustache class" do
      class HelloWorld < Stache::Mustache::View; end
      @handler.mustache_class_from_template(@template).should == HelloWorld
      Object.send(:remove_const, :HelloWorld)
    end
    it "is clever about folders and such" do
      @template.stub!(:virtual_path).and_return("profiles/index")
      module Profiles; class Index < Stache::Mustache::View; end; end
      @handler.mustache_class_from_template(@template).should == Profiles::Index
      Object.send(:remove_const, :Profiles)
    end
    it "retuns Stache::Mustache::View if it can't find none" do
      @handler.mustache_class_from_template(@template).should == Stache::Mustache::View
    end
    it "reraises error if loaded mustache_class raises a NameError" do
      @template.stub!(:virtual_path).and_return("profiles/index")
      module Profiles; end
      # Emulate autoload behavior so the error gets raised upon const_get
      Profiles.autoload :Index, File.join(File.dirname(__FILE__), "profile_autoload.rb")

      lambda {
        @handler.mustache_class_from_template(@template)
      }.should raise_error(NameError, "uninitialized constant Profiles::Index::Foo")

      Object.send(:remove_const, :Profiles)
    end
  end

  describe "#mustache_class_from_template with config module wrapper set" do
    before do
      Stache.wrapper_module_name = "Wrapper"
    end

    it "returns the appropriate mustache class" do
      module Wrapper; class HelloWorld < ::Stache::Mustache::View; end; end
      @handler.mustache_class_from_template(@template).should == Wrapper::HelloWorld
      Object.send(:remove_const, :Wrapper)
    end
    it "is clever about folders and such" do
      @template.stub!(:virtual_path).and_return("profiles/index")
      module Wrapper; module Profiles; class Index < ::Stache::Mustache::View; end; end; end
      @handler.mustache_class_from_template(@template).should == Wrapper::Profiles::Index
      Object.send(:remove_const, :Wrapper)
    end

    after do
      Stache.wrapper_module_name = nil
    end
  end
end
