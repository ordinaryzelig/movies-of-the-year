require 'active_record'

db_name = ENV['MOTY_ENV'] == 'test' ? 'movies.test.sqlite3' : 'movies.sqlite3'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/#{db_name}",
)
