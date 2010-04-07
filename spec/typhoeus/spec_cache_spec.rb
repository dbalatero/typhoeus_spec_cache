require File.dirname(__FILE__) + "/../spec_helper"

def cache_path(name)
  File.expand_path(File.dirname(__FILE__) + "/../fixtures/#{name}")
end

describe Typhoeus::SpecCache do
  before(:each) do
    @hydra = mock('hydra')
    @hydra.should_receive(:cache_setter)
    @hydra.should_receive(:cache_getter)
    @cache = Typhoeus::SpecCache.new(@hydra,
                                     cache_path('cache'))
    @request = mock('typhoeus request',
                    :cache_key => 'mykey',
                    :response => mock('typhoeus response'))
  end

  describe "#cache_setter_callback" do
    it "should cache a request" do
      @cache.cache_setter_callback(@request)
      @cache.responses['mykey'].should == @request.response
    end
  end

  describe "#cache_getter_callback" do
    it "should return nil if there is no cache hit" do
      result = @cache.cache_getter_callback(@request)
      result.should be_nil
    end

    it "should return the response if there is a cache hit" do
      @cache.cache_setter_callback(@request)
      result = @cache.cache_getter_callback(@request)
      result.should == @request.response
    end
  end

  describe "#clear_hydra_callbacks!" do
    it "should not completely die" do
      @cache.clear_hydra_callbacks!
    end
  end

  describe "#read_cache_fixtures!" do
    it "should read in cache fixtures that are dumped out" do
      @cache.cache_setter_callback(@request)
      @cache.dump_cache_fixtures!
      @cache.clear_cache!
      @cache.responses.should have(0).things

      @cache.read_cache_fixtures!
      @cache.responses.should have(1).things
      @cache.responses[@request.cache_key].should be_an_instance_of(Spec::Mocks::Mock)
    end
  end

  describe "#remove_unnecessary_cache_files!" do
    it "should remove any .cache files that are in the cache directory, but not needed" do
      @cache.cache_setter_callback(@request)
      @cache.dump_cache_fixtures!

      old_keys = ['oldkey', 'oldkey2']
      old_keys.each do |key|
        File.open(@cache.filepath_for(key), "wb") do |f|
          f.write "blah blah blah"
        end
      end

      @cache.cache_files.should have(3).things
      @cache.remove_unnecessary_cache_files!
      @cache.cache_files.should have(1).things
    end
  end

  describe "#clear_cache!" do
    it "should clear the in-memory cache" do
      @cache.cache_setter_callback(@request)
      @cache.responses.should have(1).thing
      @cache.clear_cache!
      @cache.responses.should be_empty
    end
  end

  describe "#dump_cache_fixtures!" do
    it "should dump out the responses to disk" do
      @cache.cache_setter_callback(@request)
      @cache.responses.should have(1).thing
      @cache.dump_cache_fixtures!
      @cache.responses.each do |key, response|
        path = @cache.filepath_for(key)
        File.exist?(path).should be_true

        # cleanup
        File.unlink(path)
        File.exist?(path).should be_false
      end
    end
  end

  after(:each) do
    @cache.cache_files.each { |f| File.unlink(f) }
  end
end
