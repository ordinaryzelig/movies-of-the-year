require_relative '../spec_helper'

describe Movie do

  before do
    ActiveRecord::Base.connection.execute 'delete from movies;'
  end

  it '.new_from_event returns new Movie object with data from event' do
    event = Icalendar::Event.new
    event.summary = 'Harry Potter ; 4. y'
    event.dtstart = DateTime.parse('2012-12-31 12:34')
    movie = Movie.new_from_event(event)

    movie.name.must_equal 'Harry Potter'
    movie.rating.must_equal 4
    movie.watched_before.must_equal true
    movie.watched_on.must_equal Date.civil(2012, 12, 31)
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

  describe 'event parsing' do

    def self.it_parses(summary, expected_atts)
      it "parses #{summary}" do
        movie = Movie.new(event_summary: summary)
        expected_atts.each do |att, value|
          movie.public_send(att).must_equal value
        end
      end
    end

    it_parses 'Harry Potter ; 4. y. y',
      name: 'Harry Potter',
      rating: 4,
      watched_before: true,
      new_this_year: true

    it_parses 'Harry Potter (4,y,y)',
      name: 'Harry Potter',
      rating: 4,
      watched_before: true,
      new_this_year: true

    it_parses 'Harry Potter (extended) (4,y,y)',
      name: 'Harry Potter (extended)',
      rating: 4,
      watched_before: true,
      new_this_year: true

  end

end
