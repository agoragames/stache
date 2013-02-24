module Wrapper
  module Handlebars
    class WithWrapper < ::Stache::Handlebars::View
      def answer correct_answer
        "answer: #{correct_answer}"
      end
    end
  end
end