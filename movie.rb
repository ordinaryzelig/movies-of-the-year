require 'mongoid'

Mongoid.configure do |config|
  name = 'moty'
  host = 'localhost'
  config.master = Mongo::Connection.new.db(name)
end

class Movie

  include Mongoid::Document

  field :name
  field :watched_on, :type => Date
  field :rating, :type => Integer, :default => 0
  field :sort_name
  field :watched_before, :type => Boolean

  scope :unrated, where(:rating => 0)
  scope :rated, proc { |rating = nil| rating ? where(:rating => rating) : where('rating > 0') }
  # Doesn't work as scope.
  #scope :by_sort_name, order_by([:sort_name])
  #scope :year_watched, proc { |year| ??? }

  def assign_sort_name
    self.sort_name = name.sub /^The |A /, ''
  end

  def rate!(rating)
    self.rating = rating
    save
  end

  def self.list
    movies = by_sort_name
    movies.map { |movie| "#{movie.name} (#{movie.rating})" }.uniq
  end

  def self.by_sort_name
    order_by :sort_name
  end

end
