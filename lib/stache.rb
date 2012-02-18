require "stache/version"
require "stache/config"
require "stache/util"
require "stache/handler"
require "stache/haml_handler"
require "stache/asset_helper"

if defined? ::Rails::Railtie and ::Rails::VERSION::MAJOR >= 3
  require 'stache/railtie'
end

module Stache
  extend Config
  
end

ActionView::Template.register_template_handler(:mustache, Stache::Handler)
ActionView::Template.register_template_handler('mustache.haml', Stache::HamlHandler)
ActionView::Base.send :include, Stache::AssetHelper