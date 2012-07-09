require 'mustache'

module Stache
  module Mustache
    #
    # A Convienent Base Class for the views. Subclass this for autoloading magic with your templates.
    class View < ::Mustache
      attr_accessor :view, :template, :virtual_path

      def method_missing(method, *args, &block)
        view.send(method, *args, &block)
      end

      def respond_to?(method, include_private=false)
        super(method, include_private) || view.respond_to?(method, include_private)
      end

      # Redefine where Stache::View templates locate their partials
      def partial(name)
        current_dir = Stache.template_base_path.join( self.virtual_path.split("/")[0..-2].join("/") )
        lookup_context.view_paths += [current_dir]

        template_finder = lambda do |partial|
          if ActionPack::VERSION::MAJOR == 3 && ActionPack::VERSION::MINOR < 2
            lookup_context.find(name, [], partial)
          else # Rails 3.2 and higher
            lookup_context.find(name, [], partial, [], { formats: [:html], handlers: [:mustache] })
          end
        end

        template = template_finder.call(true) rescue template_finder.call(false)
        template.source
      end

      def helpers
        self.class.helpers
      end
      alias :h :helpers

      class << self
        def helpers
          Stache::ViewContext.current
        end
        alias :h :helpers
      end
    end
  end
end
