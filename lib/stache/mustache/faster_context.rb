module Stache
  module Mustache
    class FasterContext < ::Mustache::Context

      def partial(name, indentation = nil)
        # Look for the first Mustache in the stack.
        mustache = mustache_in_stack

        # Do NOT indent the partial template by the given indentation.
        part = mustache.partial(name)

        # If we already have a template, to not convert it into a string
        part = part.to_s unless part.is_a?(::Mustache::Template)

        # Call the Mustache's `partial` method and render the result.
        mustache.render(part, self)
      end
    end
  end
end