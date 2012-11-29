# 1.0.0

* Overhauled Mustache template engine. If you wish to have Mustache drive your entire template stack, you can invert control to it.
* Fixed a bunch of problems with Handlebars access to the view namespace for helpers, etc.
* New configuration option: you can now specify a wrapper namespace that Stache will look for your view classes in.

Backwards compatibility should be fine; any regressions are bugs and should be reported.

Huge thanks to all contributors!

# 0.9.1

* soften our hardcore stance on missing properties.

# 0.9.0

/!\ /!\ Breaking Changes.

* 1.0 release candidate
* Handlebars support
* uses Rails' own template resolution system to find partials.

There's some code duplication that should be crushed out before 1.0.

# 0.2.2

* Saner, consistent handling of template extensions: partials and full templates both use configured value at `Stache.template_extension`. Thanks @ajacksified!

# 0.2.1

* Addresses #9: fix 'incompatible character encodings' error

# 0.2.0

* Patch to properly reraise NameError/LoadError that occurs upon loading a Stache::View