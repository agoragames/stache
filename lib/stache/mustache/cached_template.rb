module Stache
  module Mustache
    #
    # Extend the Mustache::Template class to support dumping/loading.
    # This is not possible by the original class since it uses a singleton class.
    #
    class CachedTemplate < ::Mustache::Template

      #
      # Init with uncompiled "source" and "compiled_source" if given.
      #
      def initialize(source, compiled_source = nil)
        super(source)
        @compiled_source = compiled_source
      end

      #
      # Compiles the source, but uses the already compiled version if
      # present.
      #
      def compile(src = @source)
        @compiled_source || (@compiled_source = super(src))
      end

      #
      # Store the template by returning the compiled_source
      #
      def _dump(level)
        compile
      end

      #
      # Restore object by simply setting the compiled_source
      #
      def self._load(compiled_source)
        new(nil, compiled_source)
      end

    end
  end
end