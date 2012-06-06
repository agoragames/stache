module Stache
  module Mustache
    # This class is for providing layouts in a better way.
    # Your page class should extend this class.
    class Layout < ::Stache::Mustache::View
      attr_writer :layout

      def layout
        @layout ||= :layout
      end

      # template here would be the pages' template, not the layout.
      def render(data = template, ctx = {})
        # Store the current template, we'll need to stuff it inside the layout
        page_template = data

        # Grab the layout template, to render it at the end
        layout_template = partial(layout)

        # Render the page_template using this class's context
        # (which will be combined with the layout context)
        rendered_template = super(page_template, ctx)

        # stick that rendered template as :yield into the layout template
        # (which will be combined with the current context)
        if (!ctx.is_a?(::Mustache::Context))
          rendered_template = super(layout_template, :yield => rendered_template)
        end

        rendered_template
      end
    end
  end
end
