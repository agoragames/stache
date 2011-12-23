require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Stache::Handler do
  # ERBHandler = ActionView::Template::Handlers::ERB.new
  # def new_template(body = "<%= hello %>", details = {})
  #   ActionView::Template.new(body, "hello template", ERBHandler, {:virtual_path => "hello"}.merge!(details))
  # end
  before do
    @template = ActionView::Template.new("{{body}}", "hello mustache", Stache::Handler, { :virtual_path => "hello_world"})
    @handler = Stache::Handler.new
  end

  describe "#mustache_class_from_template" do
    it "returns the appropriate mustache class" do
      class HelloWorld < Stache::View; end
      @handler.mustache_class_from_template(@template).should == HelloWorld
      Object.send(:remove_const, :HelloWorld)
    end
    it "is clever about folders and such" do
      @template.stub!(:virtual_path).and_return("profiles/index")
      module Profiles; class Index < Stache::View; end; end
      @handler.mustache_class_from_template(@template).should == Profiles::Index
      Object.send(:remove_const, :Profiles)
    end
    it "retuns Stache::View if it can't find none" do
      @handler.mustache_class_from_template(@template).should == Stache::View
    end
    it "reraises error if loaded mustache_class raises a NameError" do
      # Emulate autoload behavior so the error gets raised upon const_get
      module ::Foo; end
      module Profiles; class Index < Stache::View; include Foo; end; end
      Object.send(:remove_const, :Foo)
      @template.stub!(:virtual_path).and_return("profiles/index")
      
      lambda {
        @handler.mustache_class_from_template(@template)
      }.should raise_error(NameError, "uninitialized constant ::Foo")
      
      Object.send(:remove_const, :Profiles)
    end
  end
end