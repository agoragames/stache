require 'mustache'

module Stache
  #
  # A Convienent Base Class for the views. Subclass this for autoloading magic with your templates.
  #
  # e.g. if the handler is loading a template from templates/
  class View < ::Mustache
    attr_accessor :view, :template, :virtual_path

    def method_missing(method, *args, &block)
      view.send(method, *args, &block)
    end

    def respond_to?(method, include_private=false)
      super(method, include_private) || view.respond_to?(method, include_private)
    end
    
    # Redefine where Stache::View templates locate their partials:
    #
    # (1) in the same directory as the current template file.
    # (2) in the shared templates path (can be configured via Config.shared_path=(value))
    # (3) with or without leading underscore
    #
    def partial(name)
      template_dir = self.virtual_path.split("/")[0..-2].join("/")
      template_path = File.join(Stache.template_base_path, template_dir)
      partial_path = locate_partial_for(template_path, name)

      # ::Rails.logger.info "Checking for #{partial_path} in template_dir: #{template_dir}"
      if partial_path.nil?
        partial_path = locate_partial_for(Stache.shared_path, name)
        
        if partial_path.nil?
          failed_paths = potential_paths(template_path,name) + potential_paths(Stache.shared_path, name) 
          raise ActionView::MissingTemplate.new(failed_paths, name, [template_path, Stache.shared_path], true, { :handlers => [:mustache] })
        end

      end
      
      # ::Rails.logger.info "LOADING PARTIAL: #{partial_path}"
      File.read(partial_path)
    end
    
    def potential_paths(path, candidate_file_name)
      [
        File.join(path, "_#{candidate_file_name}.#{Stache.template_extension}"),
        File.join(path, "#{candidate_file_name}.#{Stache.template_extension}")
      ]
    end
    
    def locate_partial_for(path, candidate_file_name)
      potential_paths(path, candidate_file_name).find { |file| File.file?(file.to_s) }
    end
    
  end
end
