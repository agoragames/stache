# This file is intended to raise a NameError upon require
module Profiles
  class Index < Stache::Mustache::View
    include Foo
  end
end
