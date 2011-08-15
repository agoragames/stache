require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Stache::Util do
  describe ".av_template_class" do
    it "returns ActionView::Template::{Foo} if such a thing exists" do
      Stache::Util.av_template_class("Foo").should == ActionView::Template::Foo
    end
    it "returns ActionView::TemplateFoo otherwise" do
      ActionView::Template.should_receive(:const_defined?).and_return(false)
      Stache::Util.av_template_class("Foo").should == ActionView::TemplateFoo
    end
  end
  
  describe ".needs_compilable?" do
    pending "need to figure out some way to test this across different rails versions..."
  end
end