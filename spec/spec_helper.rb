ENV['MOTY_ENV'] = 'test'

require 'rubygems'
require 'bundler'
Bundler.require(:default, ENV['MOTY_ENV'].to_sym)

require 'minitest/autorun'

require_relative '../db'
require_relative '../models/movie'
require_relative '../models/movie_data_fetcher'

VCR.config do |c|
  c.cassette_library_dir = 'spec/support/fixtures/vcr_cassettes'
  c.stub_with :webmock
  c.filter_sensitive_data('<TMDB_KEY>') { ENV['TMDB_KEY'] }
end
