require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class MyViewContext
  include ActionView::Helpers::TagHelper
  include Stache::AssetHelper
end

describe Stache::AssetHelper do
  def helper
    @helper ||= MyViewContext.new
  end

  describe "#template_include_tag" do
    it "renders a script tag with the template contents" do
      File.stub!(:file?).with(Rails.root.join("app/views/widgets/_oh_herro.html.mustache").to_s).and_return(true)
      File.stub!(:open).with(Rails.root.join("app/views/widgets/_oh_herro.html.mustache"), "rb", {:encoding=>"utf-8"}).
        and_return(StringIO.new("{{ awyeah }}"))

      helper.template_include_tag("widgets/oh_herro").should == "<script id=\"oh_herro_template\" type=\"text/html\">{{ awyeah }}</script>"
    end
    it "uses the template_base_path config setting to locate the template" do
      Stache.configure do |c|
        c.template_base_path = "/tmp/whee"
      end
      File.stub!(:file?).with("/tmp/whee/_whooo.html.mustache").and_return(true)
      File.stub!(:open).with(Pathname.new("/tmp/whee/_whooo.html.mustache"), "rb", {:encoding=>"utf-8"}).
        and_return(StringIO.new("{{ awyeah }}"))

      helper.template_include_tag("whooo").should == "<script id=\"whooo_template\" type=\"text/html\">{{ awyeah }}</script>"
    end
    it "raises if it cannot find the template" do
      lambda { helper.template_include_tag("arrrgh") }.should raise_error(ActionView::MissingTemplate)
    end
  end

  describe "#locate_template_for" do
    it "tries permutations of partial names and default file extension to find the requested file" do
      File.should_receive(:file?).with("/tmp/whee/_whooo.html.mustache")
      File.should_receive(:file?).with("/tmp/whee/whooo.html.mustache").and_return(true)

      helper.locate_template_for(Pathname.new("/tmp/whee"), "whooo").should == Pathname.new("/tmp/whee/whooo.html.mustache")
    end

    it "tries permutations of partial names and configured file extension to find the requested file" do
      Stache.configure do |config|
        @current_extension = config.template_extension
        config.template_extension = 'mustache'
      end

      File.should_receive(:file?).with("/tmp/whee/_whooo.mustache")
      File.should_receive(:file?).with("/tmp/whee/whooo.mustache").and_return(true)

      helper.locate_template_for(Pathname.new("/tmp/whee"), "whooo").should == Pathname.new("/tmp/whee/whooo.mustache")

      Stache.configure do |config|
        config.template_extension = @current_extension
      end
    end


    it "returns nil if it cannot find anything" do
      helper.locate_template_for(Pathname.new("/tmp/whee"), "whooo").should be_nil
    end
  end
end
