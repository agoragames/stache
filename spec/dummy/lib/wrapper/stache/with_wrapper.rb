module Wrapper
  module Stache
    class WithWrapper < ::Stache::Mustache::View
      def answer
        "Yes"
      end
    end
  end
end