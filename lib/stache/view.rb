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
    #
    def partial(name)
      partial_name = "_#{name}.#{Stache.template_extension}"
      template_dir = self.virtual_path.split("/")[0..-2].join("/")
      partial_path = File.expand_path(File.join(Stache.template_base_path, template_dir, partial_name))
      # ::Rails.logger.info "Checking for #{partial_path} in template_dir: #{template_dir}"
      unless File.file?(partial_path)
        partial_path = "#{Stache.shared_path}/#{partial_name}"
      end
      
      # ::Rails.logger.info "LOADING PARTIAL: #{partial_path}"
      File.read(partial_path)
    end
    
  end
end