module Wrapper
  module Stache
    class NoFormatInExtensionWithWrapper < ::Stache::Mustache::View
      def format
        "format"
      end
    end
  end
end