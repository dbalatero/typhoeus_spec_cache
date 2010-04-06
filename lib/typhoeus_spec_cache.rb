require 'rubygems'
gem 'typhoeus'
require 'typhoeus'

Dir.glob(File.dirname(__FILE__) + "/**/*.rb").each do |f|
  require f
end
