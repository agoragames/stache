module Stache
  # Change these defaults in, say, an initializer.
  #
  # Stache.template_base_path = Rails.root.join('app', 'templates')
  #
  # Or with the block syntax:
  #
  # Stache.configure do |config|
  #   config.template_base_path = Rails.root.join('app', 'views', 'shared')
  #
  #   use :mustache # or :handlebars
  # end
  module Config
    attr_accessor :template_base_path, :template_extension, :template_base_class, :shared_path, :wrapper_module_name, :include_path_in_id, :template_cache

    def configure
      yield self
    end

    def template_base_path
      @template_base_path ||= ::Rails.root.join('app', 'templates')
    end

    def template_base_path= path
      @template_base_path = Pathname.new(path)
    end

    def template_extension
      @template_extension ||= 'html.mustache'
    end

    def template_extension= value
      @template_extension = value
    end

    def template_base_class
      @template_base_class ||= '::Stache::Mustache::View'
    end

    def template_base_class= value
      @template_base_class = value
    end

    def shared_path
      @shared_path ||= ::Rails.root.join('app', 'templates', 'shared')
    end

    def wrapper_module_name
      @wrapper_module_name ||= nil
    end

    def include_path_in_id
      @include_path_in_id ||= false
    end

    def include_path_in_id= boolean
      @include_path_in_id = boolean
    end

    def template_cache
      @template_cache ||= ActiveSupport::Cache::NullStore.new
    end

    def template_cache= cache
      @template_cache = cache
    end

    def use template_engine
      require "stache/#{template_engine}"
    end
  end
end