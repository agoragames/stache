require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class MyViewContext
  include ActionView::Helpers::TagHelper
  include Stache::AssetHelper

  def lookup_context
    @context ||= LookupContext.new
  end
end

class LookupContext
  def find(name, prefixes = [], partial = false, keys = [], options = {})
    raise ActionView::MissingTemplate.new(view_paths || [], name, prefixes, partial, options)
  end

  def view_paths= new_paths
    @paths = ActionView::PathSet.new(Array.wrap(new_paths))
  end

  def view_paths
    @paths
  end
end

class TemplateStub
  attr_accessor :source
  def initialize source
    self.source = source
  end
end

describe Stache::AssetHelper do
  def helper
    @helper ||= MyViewContext.new
  end

  describe "#template_include_tag" do
    it "renders a script tag with the template contents" do
      helper.lookup_context.should_receive(:find).with('widgets/oh_herro', [], true, [], anything).and_return(TemplateStub.new("{{ awyeah }}"))

      helper.template_include_tag("widgets/oh_herro").should == "<script id=\"oh_herro_template\" type=\"text/html\">{{ awyeah }}</script>"
    end
    it "renders a script tag with the template contents and given id" do
      helper.lookup_context.should_receive(:find).with('widgets/oh_herro', [], true, [], anything).and_return(TemplateStub.new("{{ awyeah }}"))

      helper.template_include_tag("widgets/oh_herro", :id => 'oh_herro_tmpl').should == "<script id=\"oh_herro_tmpl\" type=\"text/html\">{{ awyeah }}</script>"
    end
    it "renders a script tag with the template contents and given options" do
      helper.lookup_context.should_receive(:find).with('widgets/oh_herro', [], true, [], anything).and_return(TemplateStub.new("{{ awyeah }}"))

      helper.template_include_tag("widgets/oh_herro", :data => {:engine => 'mustache'}).
        should == "<script data-engine=\"mustache\" id=\"oh_herro_template\" type=\"text/html\">{{ awyeah }}</script>"
    end
    it "will find first by partial and later by non-partial" do
      helper.lookup_context.should_receive(:find).with('widgets/oh_herro', anything, true, anything, anything).and_raise(StandardError.new("noooooo"))
      helper.lookup_context.should_receive(:find).with('widgets/oh_herro', anything, false, anything, anything).and_return(TemplateStub.new("{{ awyeah }}"))

      helper.template_include_tag("widgets/oh_herro").should == "<script id=\"oh_herro_template\" type=\"text/html\">{{ awyeah }}</script>"
    end
    it "raises if it cannot find the template" do
      lambda { helper.template_include_tag("arrrgh") }.should raise_error(ActionView::MissingTemplate)
    end

    context "when config.include_path_in_id is set to true" do
      before do
        Stache.include_path_in_id = true

        helper.lookup_context.should_receive(:find)
          .with(nested_path, [], true, [], anything)
          .and_return(TemplateStub.new("{{ awyeah }}"))
      end

      after do
        Stache.include_path_in_id = false
      end

      let(:nested_path) { 'nested/path/to/oh_herro' }

      it "renders a script tag id with template path included (underscored)" do
        helper.template_include_tag(nested_path)
          .should == "<script id=\"nested_path_to_oh_herro_template\" type=\"text/html\">{{ awyeah }}</script>"
      end

      context "when template_base_path is set" do
        before do
          Stache.template_base_path = 'widgets/'
        end

        it "renders a script tag id without a template path included" do
          helper.template_include_tag(nested_path)
            .should == "<script id=\"nested_path_to_oh_herro_template\" type=\"text/html\">{{ awyeah }}</script>"
        end
      end

      context "when id option is set" do
        it "renders a script tag with given id and without a full path" do
          helper.template_include_tag(nested_path, :id => 'oh_herro_tmpl')
            .should == "<script id=\"oh_herro_tmpl\" type=\"text/html\">{{ awyeah }}</script>"
        end
      end
    end
  end


end
