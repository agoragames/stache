module Stache
  module ViewContext
    def self.current
      Thread.current[:current_view_context]
    end

    def self.current=(input)
      Thread.current[:current_view_context] = input
    end
  end

  module ViewContextFilter
    def set_current_view_context
      Stache::ViewContext.current = self.view_context
    end

    def self.included(source)
      if source.respond_to?(:before_action) # Rails 4+
        source.send(:before_action, :set_current_view_context)
      elsif source.respond_to?(:before_filter) # Rails 3
        source.send(:before_filter, :set_current_view_context)
      end
    end
  end
end
