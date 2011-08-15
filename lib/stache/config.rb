module Stache
  # Change these defaults in, say, an initializer.
  #
  # Stache.template_base_path = Rails.root.join('app', 'templates')
  #
  # Or with the block syntax:
  #
  # Stache.configure do |config|
  #   config.template_base_path = Rails.root.join('app', 'views', 'shared')
  # end
  module Config
    attr_accessor :template_base_path, :template_extension, :shared_path
    
    def configure
      yield self
    end
    
    
    def template_base_path
      @template_base_path ||= ::Rails.root.join('app', 'templates')
    end

    def template_extension
      @template_extension ||= 'html.mustache'
    end

    def shared_path
      @shared_path ||= ::Rails.root.join('app', 'templates', 'shared')
    end
  end
end