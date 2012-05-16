# This file is intended to raise a NameError upon require
module Profiles
  class Index < Stache::Handlebars::View
    include Foo
  end
end
