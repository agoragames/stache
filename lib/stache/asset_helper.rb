module Stache
  module AssetHelper
    # template_include_tag("widgets/basic_text_api_data")
    # template_include_tag("shared/test_thing")
    def template_include_tag(*sources)
      sources.collect do |source|
        exploded = source.split("/")
        file = exploded.pop
        file = file.split(".").first

        base_path = Stache.template_base_path.join(*exploded)
        template_path = locate_template_for(base_path, file)
        if template_path
          template = ::File.open(template_path, "rb" , :encoding => Rails.configuration.encoding)
          content_tag(:script, template.read.html_safe, :type => "text/html", :id => "#{file.dasherize.underscore}_template")
        else
          raise ActionView::MissingTemplate.new(potential_paths(base_path, file), file, [base_path], false, { :handlers => [:mustache] })
        end
      end.join("\n").html_safe
    end
    
    def potential_paths(path, candidate_file_name)
      [
        path.join("_#{candidate_file_name}.html.mustache"),
        path.join("_#{candidate_file_name}.mustache"),
        path.join("#{candidate_file_name}.html.mustache"),
        path.join("#{candidate_file_name}.mustache")
      ]
    end
    
    def locate_template_for(path, candidate_file_name)
      potential_paths(path, candidate_file_name).find { |file| File.file?(file.to_s) }
    end
  end
end