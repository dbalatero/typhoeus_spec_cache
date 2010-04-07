require File.dirname(__FILE__) + "/../spec_helper"

describe Typhoeus::SpecCacheMacros do
  describe "#typhoeus_spec_cache" do
    include Typhoeus::SpecCacheMacros::ClassMethods
    before(:each) do
      @path = "path/to/cache"
      @cache = mock('spec cache')
      Typhoeus::SpecCache.should_receive(:new).
        with(an_instance_of(Typhoeus::Hydra), @path).and_return(@cache)
      @cache.should_receive(:remove_unnecessary_cache_files!).ordered
      @cache.should_receive(:dump_cache_fixtures!).ordered
      @cache.should_receive(:clear_hydra_callbacks!)

      self.should_receive(:before).with(:each).
        and_yield
      self.should_receive(:stub_hydra).
        with(an_instance_of(Typhoeus::Hydra))
      self.should_receive(:after).
        with(:all).
        and_yield

      @value_to_modify = nil
      block_to_run = lambda { |hydra|
        @value_to_modify = 50
      }

      typhoeus_spec_cache(@path, &block_to_run)
    end

    it "should run the block successfully" do
      @value_to_modify.should == 50
    end
  end
end
