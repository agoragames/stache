require 'handlebars'

module Stache
  module Handlebars
    #
    # A Convienent Base Class for the views. Subclass this for autoloading magic with your templates.
    class View < ::Handlebars::Context
      attr_accessor :view

      def method_missing(method, *args, &block)
        view.send(method, *args, &block)
      end

    end
  end
end