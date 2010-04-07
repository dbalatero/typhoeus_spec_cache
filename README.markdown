typhoeus\_spec\_cache
-------------------

Typhoeus is a great frontend to Curl/Curl::Multi. However, if you have a large spec suite that hits a number of external HTTP resources, you will quickly find yourself getting tired of caching all those resources by hand! Trust me. No seriously, I hate doing this by hand.

Thanks to [Paul Dix](http://github.com/pauldix) for writing Typhoeus!

Usage
-----

In any specs that hit HTTP via `Typhoeus::Hydra`, wrap them in a `typhoeus_spec_cache` block:

    describe "making 30 expensive HTTP calls" do
      typhoeus_spec_cache("spec/cache/mycache") do |hydra|
        it "should get 10 URLs" do
          result = fetch_urls(10)
          result.should have(10).things
        end

        it "should get 20 URLs" do
          result = fetch_urls(20)
          result.should have(20).things
        end
      end
    end

Create the cache directory:

    mkdir -p spec/cache/mycache

On the first run of these two specs, Typhoeus will make 30 live HTTP requests. These will then be dumped out to `.cache` files in `spec/cache/mycache`, and used on subsequent runs, avoiding any future HTTP calls.

Auto-stubbing of Hydra
----------------------

Calling `typhoeus_spec_cache` automatically stubs out calls to `Typhoeus::Hydra#new` with a single shared Hydra object.

Auto-managing of cache files
----------------------------

If the URLs your code hits ever changes, the `typhoeus_spec_cache` wrapper is smart about handling your cache. It will:

* Only download new URLs it hasn't seen.
* Remove any `.cache` files that aren't needed anymore.

This way, your cache directory will contain exactly the `.cache` files you need, and no more.

Installation
------------

    sudo gem install typhoeus_spec_cache

Then, add the following to your spec/spec_helper.rb

    require 'typhoeus_spec_cache'

And add these two lines to your `Spec::Runner.configure` block in `spec/spec_helper.rb`:

    Spec::Runner.configure do |config|
      config.include(Typhoeus::SpecCacheMacros::InstanceMethods)
      config.extend(Typhoeus::SpecCacheMacros::ClassMethods)
    end

Note on Patches/Pull Requests
-----------------------------
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2010 David Balatero. See LICENSE for details.
