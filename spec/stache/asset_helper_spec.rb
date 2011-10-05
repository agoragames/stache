require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class MyViewContext
  include ActionView::Helpers::TagHelper
  include Stache::AssetHelper
end

describe Stache::AssetHelper do
  def helper
    @helper ||= MyViewContext.new
  end
  
  describe "template_include_tag" do
    it "renders a script tag with the template contents" do
      File.stub!(:open).with(Rails.root.join("app/views/widgets/_oh_herro.html.mustache"), "rb").
        and_return(StringIO.new("{{ awyeah }}"))

      helper.template_include_tag("widgets/oh_herro").should == "<script id=\"oh_herro_template\" type=\"text/html\">{{ awyeah }}</script>"
    end
    it "uses the template_base_path config setting to locate the template" do
      Stache.configure do |c|
        c.template_base_path = "/tmp/whee"
      end
      File.stub!(:open).with(Pathname.new("/tmp/whee/_whooo.html.mustache"), "rb").
        and_return(StringIO.new("{{ awyeah }}"))
        
      helper.template_include_tag("whooo").should == "<script id=\"whooo_template\" type=\"text/html\">{{ awyeah }}</script>"
    end
  end
end