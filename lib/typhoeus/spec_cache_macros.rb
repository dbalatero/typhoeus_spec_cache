module Typhoeus
  module SpecCacheMacros
    def typhoeus_spec_cache(hydra, cache_path, &block)
      cache = SpecCache.new(hydra, cache_path)

      yield block

      cache.remove_unnecessary_cache_files!
      cache.dump_cache_fixtures!
      cache.clear_hydra_callbacks!
    end
  end
end
