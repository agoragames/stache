require 'stache/mustache/view'

module Stache
  module Mustache
    # From HAML, thanks a bunch, guys!
    # In Rails 3.1+, template handlers don't inherit from anything. In <= 3.0, they do.
    # To avoid messy logic figuring this out, we just inherit from whatever the ERB handler does.
    class Handler < Stache::Util.av_template_class(:Handlers)::ERB.superclass
      if Stache::Util.needs_compilable?
        include Stache::Util.av_template_class(:Handlers)::Compilable
      end

      # Thanks to Mustache::Rails3 for getting us most of the way home here
      def compile(template)
        #
        # get a custom Mustache, or the default Stache::Mustache::View
        mustache_class = mustache_class_from_template(template)

        # If the class is in the same directory as the template, the source of the template can be the
        # source of the class, and so we need to read the template source from the file system.
        # Matching against `module` may seem a bit hackish, but at worst it provides false positives
        # only for templates containing the word `module`, and reads the template again from the file
        # system.

        template_source = if template.source.match(/module/)
          template_name = template.virtual_path.to_s
          file = Dir.glob(File.join(::Stache.template_base_path, template_name + "\.*" + ::Mustache.template_extension)).first
          File.read(file)
        else
          template.source.gsub(/'/, "\\\\'")
        end

        virtual_path = template.virtual_path.to_s

        # Caching key
        template_id = "#{template.identifier.to_s}#{template.updated_at.to_i}"

        # Return a string that will be eval'd in the context of the ActionView, ugly, but it works.
        <<-MUSTACHE
          mustache = ::#{mustache_class}.new
          mustache.view = self

          mustache.virtual_path = '#{virtual_path}'
          mustache[:yield] = content_for(:layout)
          mustache.context.update(local_assigns)
          variables = controller.instance_variables
          variables.delete(:@template)
          variables -= controller.class.protected_instance_variables.to_a

          variables.each do |name|
            mustache.instance_variable_set(name, controller.instance_variable_get(name))
          end

          # Add view instance variables also so RSpec view spec assigns will work
          (instance_variable_names - variables).each do |name|
            mustache.instance_variable_set(name, instance_variable_get(name))
          end

          # Declaring an +attr_reader+ for each instance variable in the
          # Stache::Mustache::View subclass makes them available to your templates.
          mustache.singleton_class.class_eval do
            attr_reader *variables.map { |name| name.to_s.sub(/^@/, '').to_sym }
          end

          # Setup cache
          unless self.class.instance_variable_defined?(:@mustache_template_cache)
            self.class.instance_variable_set(:@mustache_template_cache, {})
          end
          cache = self.class.instance_variable_get(:@mustache_template_cache)

          # Try to set template from cache, otherwise use template source
          template_cached   = cache['#{template_id}']
          mustache.template = template_cached || '#{template_source}'

          # Render - this will also compile the template
          compiled = mustache.render.html_safe

          # Store now compiled template
          unless template_cached
            cache['#{template_id}'] = mustache.template
          end

          compiled
        MUSTACHE
      end

      # In Rails 3.1+, #call takes the place of #compile
      def self.call(template)
        new.compile(template)
      end

      # suss out a constant name for the given template
      def mustache_class_from_template(template)
        # If we don't have a source template to render, return an abstract view class.
        # This is normally used with rspec-rails. You probably never want to normally
        # render a bare Stache::View
        if template.source.empty?
          return Stache::Mustache::View
        end

        const_name = ActiveSupport::Inflector.camelize(template.virtual_path.to_s)
        const_name = "#{Stache.wrapper_module_name}::#{const_name}" if Stache.wrapper_module_name
        begin
          const_name.constantize
        rescue NameError, LoadError => e
          # Only rescue NameError/LoadError concerning our mustache_class
          if e.message.match(/#{const_name}$/)
            Stache::Mustache::View
          else
            raise e
          end
        end
      end

    end
  end
end
