require 'active_record'
require 'sqlite3'

db_name = ENV['MOTY_ENV'] == 'test' ? 'movies.test.sqlite3' : 'movies.sqlite3'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => db_name,
)
