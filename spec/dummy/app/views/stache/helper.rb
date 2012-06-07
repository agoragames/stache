module Stache
  class Helper < Stache::Mustache::View
    def url
      h.stache_path
    end
  end
end
