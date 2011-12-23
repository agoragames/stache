require 'stache/view'

module Stache
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
      # get a custom Mustache, or the default Stache::View
      mustache_class = mustache_class_from_template(template)
    
      # Return a string that will be eval'd in the context of the ActionView, ugly, but it works.
      <<-MUSTACHE
        mustache = ::#{mustache_class}.new
        mustache.view = self
        mustache.template = '#{template.source.gsub(/'/, "\\\\'")}'
        mustache.virtual_path = '#{template.virtual_path.to_s}'
        mustache[:yield] = content_for(:layout)
        mustache.context.update(local_assigns)
        variables = controller.instance_variable_names
        variables -= %w[@template]
  
        if controller.respond_to?(:protected_instance_variables)
          variables -= controller.protected_instance_variables
        end
  
        variables.each do |name|
          mustache.instance_variable_set(name, controller.instance_variable_get(name))
        end
  
        # Declaring an +attr_reader+ for each instance variable in the
        # Stache::View subclass makes them available to your templates.
        mustache.class.class_eval do
          attr_reader *variables.map { |name| name.sub(/^@/, '').to_sym }
        end

        mustache.render.html_safe
      MUSTACHE
    end
  
    # In Rails 3.1+, #call takes the place of #compile
    def self.call(template)
      new.compile(template)
    end

    # suss out a constant name for the given template
    def mustache_class_from_template(template)
      const_name = ActiveSupport::Inflector.camelize(template.virtual_path.to_s)
      begin
        const_name.constantize
      rescue NameError, LoadError => e
        # Only rescue NameError/LoadError concerning our mustache_class
        if e.message.include?(const_name)
          Stache::View
        else
          raise e
        end
      end
    end

  end
end