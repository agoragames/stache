module Wrapper
  module Handlebars
    class WithWrapper < ::Stache::Handlebars::View
      def answer
        "Yes"
      end
    end
  end
end