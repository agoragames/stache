# stache

A Rails 3.x compatible Mustache/Handlebars Template Handler, with support for partials and a couple extra niceties to make sharing the raw templates with client-side javascript a little easier. It's a one-stop shop for your facial-hair-inspired templates.

[![Build Status](https://secure.travis-ci.org/agoragames/stache.png)](http://travis-ci.org/agoragames/stache)

## 1.0.0

Major overhaul to the mustache side of things. Backwards compatibility *should* be intact. If not, file a bug and it will get taken care of.

Handlebars can also handle application layouts, and you can use subclasses of Stache::Handlebars::View to define view-specific helpers now.

## Notice Of Breaking Changes

Stache 0.9.x adds handlebars support. In the process, the public API has changed *ever-so-slightly*. Specifically, you'll need to require the mustache or handlebars gems on your own, **and** you'll need to tell Stache which one (or both!) you want to use. Add `config.use :mustache` to your initializer.

## Usage

    gem "mustache" # or "handlebars"
    gem "stache"

Install the gem. If you want to override any of the configuration options (see `stache/config`), toss an initializer in `config/initializers` and:

```ruby
Stache.configure do |c|
  c.template_base_path = "..."  # this is probably the one you'll want to change
                                # it defaults to app/templates

  c.wrapper_module_name = "..." # this lets you indicate the name of a module that
                                # namespaces all your view classes, useful, if you
                                # have a naming conflict, such as with a mailer

  # N.B. YOU MUST TELL STACHE WHICH TO USE:
  c.use :mustache
  # and / or
  c.use :handlebars
end

# or if the block style ain't yer thang, just:
Stache.template_base_path = File.join(Rails.root, "app", "şablon")
```

There is as of right now one provided helper, `template_include_tag`. Give it the name of a partial and it will write it raw to a script block.

## A View Class of your Very Own

To facilitate easy integration, 'Stache comes packaged with a fully-functioning subclass of Mustache, called `Stache::Mustache::View`. It will try to find a more appropriate view class to provide to the template renderer based on the template name, but if one cannot be found it will automatically give ya a `Stache::Mustache::View` so you can have *something*.

Needless to say, it's probably better if your custom View objects are subclasses of `Stache::Mustache::View`. That way we can all be sure that the handler will render correctly.

An example by way of explanation:

With a template `app/templates/profiles/index`, Stache will look for a view named `Profiles::Index`, and, if not found, will just use the base `Stache::Mustache::View`. Stache adds `app/views` to Rails' autoload paths, so here's a sample directory structure and some sample files:

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
  class Index < ::Stache::Mustache::View
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

With the wrapper_module_name configuration set to "Wrapper":

With a template `app/templates/profiles/index`, Stache will look for a view named `Wrapper::Profiles::Index`, and, if not found, will just use the base `Stache::Mustache::View`.

### Handlebars?

Handlebars will have full access to your rails view helpers.

```
I'm a handlebars template. Look at me call a helper: {{{image_path my_image}}}
```

You can subclass `Stache::Handlebars::View` in the same way as mustache above, but there isn't as much point in doing so.

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
* cowboyd's [handlebars.rb](https://github.com/cowboyd/handlebars.rb)

So: thanks a ton to those guys.

## Contributors

* [afeld](https://github.com/afeld) provided 1.8.7 compatibility fixes.
* [subwindow](https://github.com/subwindow) provided some much needed love for Stache::Mustache::View exception handling.
* [solotimes](https://github.com/solotimes) provided better support for non-standard encodings.
* [ajacksified](https://github.com/ajacksified) cleaned up template extension handling.
* [ayamomiji](https://github.com/ayamomiji) extended the `#template_include_tag` to pass through the full range of `#content_tag` options.
* [awestendorf](https://github.com/awestendorf) requested that `View#partial` not be so particular about leading underscores. Though I didn't use his code, his prompt lead me to investigate how to properly use Rails' internal template lookup code.
* [zombor](https://github.com/zombor) contributed an overhaul to the Mustache renderer that puts Mustache classes themselves in control of the render chain, not Rails.
* [kategengler](https://github.com/kategengler) contributed a patch to allow folks to specify a namespace for their view objects.

Thanks a ton to all of the contributors as well. This would never have grown beyond a mediocre tool that rendered partials without their help!

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011-2013 Matt Wilson / Agora Games. See LICENSE for details.
