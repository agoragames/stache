require "stache/mustache/handler"

module Stache
  module Mustache; end
end

ActionView::Template.register_template_handler :rb, Stache::Mustache::Handler
ActionView::Template.register_template_handler :mustache, Stache::Mustache::Handler
