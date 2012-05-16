require 'handlebars'

module Stache
  module Handlebars
    #
    # A Convienent Base Class for the views. Subclass this for autoloading magic with your templates.
    class View < ::Handlebars::Context

      # crickets. So, this isn't as useful right now since you have to call #register_helper
      # and #partial_missing on the instance, but I'm sure we'll find a use for it :).

    end
  end
end