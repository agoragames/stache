module Stache
  class System
    def self.setup
      ActionController::Base.send(:include, Stache::ViewContextFilter)
    end
  end
end
