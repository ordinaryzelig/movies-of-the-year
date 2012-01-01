ENV['MOTY_ENV'] = 'test'

require 'rubygems'
require 'minitest/autorun'
require 'minitest/spec'
require 'awesome_print'

require_relative '../db'
require_relative '../movie'

describe Movie do

  before do
    ActiveRecord::Base.connection.execute 'delete from movies;'
  end

  it '#name_with_rating= parses and assigns name and rating' do
    name_with_rating = 'Harry Potter (4)'
    movie = Movie.new(name_with_rating: name_with_rating)
    movie.name.must_equal 'Harry Potter'
    movie.rating.must_equal 4
  end

  it 'validates #rating to be nil or between 1 and 5' do
    movie = Movie.new
    # Rating is nil, valid.
    movie.valid?
    movie.errors[:rating].must_be_empty
    # Rating is 0, not valid.
    movie.rating = 0
    movie.valid?
    movie.errors[:rating].wont_be_nil
    # Rating is 1, valid.
    movie.rating = 1
    movie.valid?
    movie.errors[:rating].must_be_empty
  end

  it 'assigns sort name when name assigned' do
    movie = Movie.new(name: 'The Dark Knight')
    movie.sort_name.must_equal 'Dark Knight'
  end

  it '.watched_in returns movies watched in year' do
    movie1 = Movie.create!(name: 'beginning of year',  watched_on: '2011-1-1')
    movie2 = Movie.create!(name: 'end of year',        watched_on: '2011-12-31')
    movies = Movie.watched_in(2011)
    [movie1, movie2].each do |movie|
      movies.must_include movie
    end
  end

end
