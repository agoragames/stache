module Stache
  # Basically a dumping ground for code that didn't fit anywhere else
  module Util
    # From HAML
    # Returns an ::ActionView::Template* class.
    # In pre-3.0 versions of Rails, most of these classes
    # were of the form `::ActionView::TemplateFoo`,
    # while afterwards they were of the form `::ActionView::Template::Foo`.
    #
    # @param name [#to_s] The name of the class to get.
    #   For example, `:Error` will return `::ActionView::TemplateError`
    #   or `::ActionView::Template::Error`.
    def self.av_template_class(name)
      if ::ActionView::Template.const_defined?(name)
        ::ActionView::Template.const_get(name)
      else
        ::ActionView.const_get("Template#{name}")
      end
    end
    
    def self.needs_compilable?
      (
        (defined?(::ActionView::TemplateHandlers) && defined?(::ActionView::TemplateHandlers::Compilable)) ||
        (defined?(::ActionView::Template) && defined?(::ActionView::Template::Handlers) && defined?(::ActionView::Template::Handlers::Compilable))
      ) &&
        # In Rails 3.1+, we don't need to include Compilable.
      Stache::Util.av_template_class(:Handlers)::ERB.include?( Stache::Util.av_template_class(:Handlers)::Compilable )
      
    end
  end
end