module Typhoeus
  class SpecCache
    attr_accessor :responses
    attr_accessor :cache_path
    attr_reader :hydra

    def initialize(hydra, cache_path)
      @responses = {}
      @cache_path = cache_path

      @hydra = hydra
      @hydra.cache_setter do |request|
        cache_setter_callback(request)
      end
      @hydra.cache_getter do |request|
        cache_getter_callback(request)
      end

      read_cache_fixtures!
    end

    def cache_setter_callback(request)
      responses[request.cache_key] = request.response
    end

    def cache_getter_callback(request)
      responses[request.cache_key]
    end

    def filepath_for(cache_key)
      "#{cache_path}/#{cache_key}.cache"
    end

    # Removes any cache files that aren't needed anymore
    def remove_unnecessary_cache_files!
      current_keys = cache_files.map do |file|
        get_cache_key_from_filename(file)
      end
      inmemory_keys = responses.keys

      unneeded_keys = current_keys - inmemory_keys
      unneeded_keys.each do |key|
        File.unlink(filepath_for(key))
      end
    end

    # Reads in the cache fixture files to in-memory cache.
    def read_cache_fixtures!
      files = cache_files
      files.each do |file|
        cache_key = get_cache_key_from_filename(file)
        responses[cache_key] = Marshal.load(File.read(file))
      end
    end

    # Dumps out any cached items to disk.
    def dump_cache_fixtures!
      responses.each do |cache_key, response|
        path = filepath_for(cache_key)
        unless File.exist?(path)
          File.open(path, "wb") do |fp|
            fp.write(Marshal.dump(response))
          end
        end
      end
    end

    def clear_hydra_callbacks!
      if hydra.respond_to?(:clear_cache_callbacks)
        hydra.clear_cache_callbacks
      else
        # you like that? do you?!?!
        hydra.instance_variable_set("@cache_setter", nil)
        hydra.instance_variable_set("@cache_getter", nil)
      end
    end

    def clear_cache!
      @responses = {}
    end

    def cache_files
      Dir.glob("#{cache_path}/*.cache")
    end

    private
    def get_cache_key_from_filename(file)
      File.basename(file).gsub(/\.cache/, '')
    end
  end
end
