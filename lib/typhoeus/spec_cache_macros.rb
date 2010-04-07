module Typhoeus
  module SpecCacheMacros
    module InstanceMethods
      def stub_hydra(hydra)
        Typhoeus::Hydra.stub(:new).
          and_return(hydra)
      end
    end

    module ClassMethods
      def typhoeus_spec_cache(cache_path, &block)
        hydra = Typhoeus::Hydra.new
        cache = SpecCache.new(hydra, cache_path)

        before(:each) do
          stub_hydra(hydra)
        end

        yield hydra

        after(:all) do
          cache.remove_unnecessary_cache_files!
          cache.dump_cache_fixtures!
          cache.clear_hydra_callbacks!
        end
      end
    end
  end
end
