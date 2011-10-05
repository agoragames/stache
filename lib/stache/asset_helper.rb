module Stache
  module AssetHelper
    # template_include_tag("widgets/basic_text_api_data")
    # template_include_tag("shared/test_thing")
    def template_include_tag(*sources)
      sources.collect do |source|
        exploded = source.split("/")
        file = exploded.pop
        file = file.split(".").first
        template_path = Stache.template_base_path.join(exploded.join("/"), "_#{file}.html.mustache")
        template = ::File.open(template_path, "rb")
        content_tag(:script, template.read.html_safe, :type => "text/html", :id => "#{file.dasherize.underscore}_template")
      end.join("\n").html_safe
    end
  end
end