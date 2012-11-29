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
    attr_accessor :template_base_path, :shared_path, :wrapper_module_name

    def configure
      yield self
    end

    def template_base_path
      @template_base_path ||= ::Rails.root.join('app', 'templates')
    end

    def template_base_path= path
      @template_base_path = Pathname.new(path)
    end

    def shared_path
      @shared_path ||= ::Rails.root.join('app', 'templates', 'shared')
    end

    def wrapper_module_name
      @wrapper_module_name ||= nil
    end

    def use template_engine
      require "stache/#{template_engine}"
    end
  end
end