module Stache
  class Ivar < Stache::Mustache::View
    def user
      @user_name
    end
  end
end
