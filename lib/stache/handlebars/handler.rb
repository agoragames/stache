require 'stache/handlebars/view'

module Stache
  module Handlebars
    # From HAML, thanks a bunch, guys!
    # In Rails 3.1+, template handlers don't inherit from anything. In <= 3.0, they do.
    # To avoid messy logic figuring this out, we just inherit from whatever the ERB handler does.
    class Handler < Stache::Util.av_template_class(:Handlers)::ERB.superclass
      if Stache::Util.needs_compilable?
        include Stache::Util.av_template_class(:Handlers)::Compilable
      end

      def compile(template)
        handlebars_class = handlebars_class_from_template(template)
        <<-RUBY_CODE
          handlebars = ::#{handlebars_class}.new
          handlebars.view = self

          handlebars.register_helper('helperMissing') do |name, *args|
            meth, *params, options = args

            if handlebars.respond_to?(meth)
              handlebars.send(meth, *params)
            elsif self.respond_to?(meth)
              self.send(meth, *params)
            elsif params.size == 0
              ""
            else
              raise "Could not find property '\#\{meth\}'"
            end
          end

          handlebars.register_helper('yield') do |name, *args|
            content_for(:layout)
          end

          template = handlebars.compile('#{template.source.gsub(/'/, "\\\\'")}');
          vars = {}
          partial_renderer = @view_renderer.send(:_partial_renderer)
          vars.merge!(@_assigns)
          vars.merge!(partial_renderer.instance_variable_get('@locals') || {})
          options = partial_renderer.instance_variable_get('@options')
          vars.merge!(options[:context] || {}) if options

          handlebars.partial_missing do |name|
            search_path = '#{template.virtual_path}'.split("/")[0..-2]
            file = (search_path + [name]).join("/")
            finder = lambda do |partial|
              self.lookup_context.find(file, [], partial, [], {:formats => [:html]})
            end
            template = finder.call(false) rescue finder.call(true)

            if template
              t = handlebars.compile(template.source)
              t.call(vars).html_safe
            else
              raise "Could not find template '\#\{file\}'"
            end
          end

          template.call(vars).html_safe
        RUBY_CODE
      end

      # In Rails 3.1+, #call takes the place of #compile
      def self.call(template)
        new.compile(template)
      end

      # suss out a constant name for the given template
      def handlebars_class_from_template(template)
        const_name = ActiveSupport::Inflector.camelize(template.virtual_path.to_s)
        const_name = "#{Stache.wrapper_module_name}::#{const_name}" if Stache.wrapper_module_name

        begin
          const_name.constantize
        rescue NameError, LoadError => e
          # Only rescue NameError/LoadError concerning our mustache_class
          if e.message.match(/#{const_name}$/)
            Stache::Handlebars::View
          else
            raise e
          end
        end
      end

    end
  end
end