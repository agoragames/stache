require 'mustache'

module Stache
  #
  # A Convienent Base Class for the views. Subclass this for autoloading magic with your templates.
  #
  # e.g. if the handler is loading a template from templates/
  class View < ::Mustache
    attr_accessor :view, :template

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
      template_dir = Pathname.new(self.class.template_file).dirname
      partial_path = File.expand_path(File.join(Stache.template_base_path, template_dir, partial_name))
      unless File.file?(partial_path)
        partial_path = "#{Stache.shared_path}/#{partial_name}"
      end
      
      # ::Rails.logger.info "LOADING PARTIAL: #{partial_path}"
      File.read(partial_path)
    end
    
  end
end