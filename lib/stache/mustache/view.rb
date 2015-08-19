require 'mustache'

module Stache
  module Mustache
    #
    # A Convienent Base Class for the views. Subclass this for autoloading magic with your templates.
    class View < ::Mustache
      attr_accessor :view, :virtual_path

      def context
        # Use the faster context instead of the original mustache one
        @context ||= FasterContext.new(self)
      end

      def method_missing(method, *args, &block)
        if view_method_arity_matches?(method, *args)
          view.send(method, *args, &block)
        else
          super
        end
      end

      def respond_to?(method, include_private=false)
        super(method, include_private) || view.respond_to?(method, include_private)
      end

      def virtual_path=(path)
        @virtual_path = path
        #
        # Since the addition to the lookup_context only depends on the virtual_path,
        # do it here instead of inside the partial.
        #
        current_dir   = Stache.template_base_path.join(path.split("/")[0..-2].join("/"))
        lookup_context.view_paths << current_dir unless lookup_context.view_paths.include?(current_dir)
      end

      # Redefine where Stache::View templates locate their partials
      def partial(name)
        cache_key = :"#{virtual_path}/#{name}"

        # Try to resolve template from cache
        template_cached = ::Stache.template_cache.read(cache_key, :namespace => :partials, :raw => true)
        curr_template   = template_cached || Stache::Mustache::CachedTemplate.new(
          begin # Try to resolve the partial template
            template_finder(name, true)
          rescue ActionView::MissingTemplate
            template_finder(name, false)
          end.source
        )

        # Store the template
        unless template_cached
          ::Stache.template_cache.write(cache_key, curr_template, :namespace => :partials, :raw => true)
        end

        curr_template
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

    protected
      def template_finder(name, partial)
        if ActionPack::VERSION::MAJOR == 3 && ActionPack::VERSION::MINOR < 2
          lookup_context.find(name, [], partial)
        else # Rails 3.2 and higher
          lookup_context.find(name, [], partial, [], { formats: [:html], handlers: [:mustache] })
        end
      end

      ##
      # Check number of parameters for method delegation to view
      def view_method_arity_matches?(method, *args)
        @_view_methods_arity ||= {}
        if @_view_methods_arity.key?(method) && @_view_methods_arity[method].key?(args.size)
          return @_view_methods_arity[method][args.size]
        end
        @_view_methods_arity[method] ||= {}

        return false unless view.respond_to?(method, true)

        view_method_parameters = view.method(method).parameters
        req_parameters = view_method_parameters.select { |p| p.first == :req }
        opt_parameters = view_method_parameters.select { |p| p.first == :opt }
        rest_parameters = view_method_parameters.select { |p| p.first == :rest }

        res = if args.size < req_parameters.size
                false
              elsif rest_parameters.blank? && args.size > (req_parameters.size + opt_parameters.size)
                false
              else
                true
              end

        @_view_methods_arity[method][args.size] = res
      end

    end
  end
end
