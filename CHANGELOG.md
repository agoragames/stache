# 0.2.2

* Saner, consistent handling of template extensions: partials and full templates both use configured value at `Stache.template_extension`. Thanks @ajacksified!

# 0.2.1

* Addresses #9: fix 'incompatible character encodings' error

# 0.2.0

* Patch to properly reraise NameError/LoadError that occurs upon loading a Stache::View