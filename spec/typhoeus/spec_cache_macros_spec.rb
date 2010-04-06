require File.dirname(__FILE__) + "/../spec_helper"

describe Typhoeus::SpecCacheMacros do
  include Typhoeus::SpecCacheMacros

  describe "#typhoeus_spec_cache" do
    before(:each) do
      @path = "path/to/cache"
      @hydra = mock('hydra')
      @cache = mock('spec cache')
      Typhoeus::SpecCache.should_receive(:new).
        with(@hydra, @path).and_return(@cache)
      @cache.should_receive(:remove_unnecessary_cache_files!).ordered
      @cache.should_receive(:dump_cache_fixtures!).ordered
      @cache.should_receive(:clear_hydra_callbacks!)

      @value_to_modify = nil
      block_to_run = lambda {
        @value_to_modify = 50
      }

      typhoeus_spec_cache(@hydra, @path, &block_to_run)
    end

    it "should run the block successfully" do
      @value_to_modify.should == 50
    end
  end
end
