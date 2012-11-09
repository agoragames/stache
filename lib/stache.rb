require "stache/version"
require "stache/config"
require "stache/util"
require "stache/asset_helper"
require "stache/view_context"
require "stache/system"

if defined? ::Rails::Railtie and ::Rails::VERSION::MAJOR >= 3
  require 'stache/railtie'
end

module Stache
  extend Config

end

ActionView::Base.send :include, Stache::AssetHelper
