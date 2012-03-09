# stache

A Rails 3.x compatible Mustache Template Handler, with support for partials and a couple extra niceties to make sharing the raw templates with client-side javascript a little easier.

## Usage

    gem "stache"

Install the gem. If you want to override any of the configuration options (see `stache/config`), toss an initializer in `config/initializers` and:

```ruby
Stache.configure do |c|
  c.template_base_path = "..."  # this is probably the one you'll want to change
                                # it defaults to app/templates
end

# or if the block style ain't yer thang, just:
Stache.template_base_path = File.join(Rails.root, "app", "şablon")
```

There is as of right now one provided helper, `template_include_tag`. Give it the name of a partial and it will write it raw to a script block. On the todo list is the ability to customize this helper a little more :).

## A View Class of your Very Own

To facilitate easy integration, 'Stache comes packaged with a fully-functioning subclass of Mustache, called `Stache::View`. It will try to find a more appropriate view class to provide to the template renderer based on the template name, but if one cannot be found it will automatically give ya a `Stache::View` so you can have *something*.

Needless to say, it's probably better if your custom View objects are subclasses of `Stache::View`. That way we can all be sure that the handler will render correctly.

An example by way of explanation:

With a template `app/templates/profiles/index`, Stache will look for a view named `Profiles::Index`, and, if not found, will just use the base `Stache::View`. Stache adds `app/views` to Rails' autoload paths, so here's a sample directory structure and some sample files:

```
app/
  templates/
    profiles/
      index.html.mustache
  views/
    profiles/
      index.rb
```

```ruby
# in profiles/index.rb
module Profiles
  class Index < ::Stache::View
    def my_view_helper_method
      "whoo"
    end
  end
end
```

```html
<!-- in the view, then -->
<p>Here's a helper_method call: {{ my_view_helper_method }}</p>
```

## Of Note

This is code that was ripped out of a research project. It probably has some rough edges.

TODO:

* more and better integration tests
* automated tests across different rails versions
* other helpers, etc, as desired

## Thanks to

This project builds on work done by the following people and projects:

* olivernn's [Poirot](https://github.com/olivernn/poirot)
* goodmike's [mustache_rails3](https://github.com/goodmike/mustache_rails3)
* nex3's [HAML](https://github.com/nex3/haml)

So: thanks a ton to those guys.

## Contributors

* [afeld](https://github.com/afeld) provided 1.8.7 compatibility fixes.
* [subwindow](https://github.com/subwindow) provided some much needed love for Stache::View exception handling.
* [solotimes](https://github.com/solotimes) provided better support for non-standard encodings.
* [ajacksified](https://github.com/ajacksified) cleaned up template extension handling.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Matt Wilson / Agora Games. See LICENSE for details.
