module Stache
  module AssetHelper
    # template_include_tag("widgets/basic_text_api_data")
    # template_include_tag("shared/test_thing")
    def template_include_tag(*sources)
      options = sources.extract_options!
      sources.collect do |source|
        lookup_context.view_paths = [Stache.template_base_path]

        template_finder = lambda do |partial|
          lookup_context.find(source, [], partial, [], { formats: [:html] })
        end

        template = template_finder.call(true) rescue template_finder.call(false)
        template_id = source.split("/").last

        options = options.reverse_merge(:type => "text/html", :id => "#{template_id.dasherize.underscore}_template")
        content_tag(:script, template.source, options)

      end.join("\n").html_safe
    end

  end
end
