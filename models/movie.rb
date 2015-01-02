require_relative '../db/db'
DB.connect
require_relative '../lib/date_extensions'
require          'icalendar'

class Movie < ActiveRecord::Base

  scope :unrated,               where(rating: nil)
  scope :rated,                 where('rating IS NOT NULL')
  scope :with_rating,           proc { |rating| where(rating: rating) }
  scope :best,                  with_rating(4..5)
  scope :worst,                 with_rating(1..2)
  scope :watched_before,        proc { |bool| where(watched_before: bool) }

  # Order scopes.
  scope :by_name,   order(:sort_name)
  scope :by_rating, order(:rating)

  validates :rating, inclusion: {in: 1..5, allow_nil: true}

  class << self

    def new_from_event(event)
      new(
        event_summary:  event.summary,
        watched_on:     event.dtstart.to_date,
      )
    end

    # Scope for year watched using date range.
    def watched_in(year)
      date_range = Date.beginning_of_year(year.to_i)..Date.end_of_year(year.to_i)
      where(watched_on: date_range)
    end

  end

  # Parse event summary with format: title (rating, watched_before),
  # assign to name, rating, watched_before.
  def event_summary=(string)
    *names, self.stats = string.split(/;|\(/)
    self.name = names.join('(')
  end

  # Assign sort name after assigning name.
  def name=(string)
    super(string.strip)
    assign_sort_name
  end

  def stats=(stats_string)
    (
      rating,
      watched_before,
      new_this_year,
    ) = stats_string.scan /\w|\d/
    self.rating = Integer(rating)
    self.watched_before = string_to_boolean(watched_before)
    self.new_this_year = string_to_boolean(watched_before)
  end

  def listing
    "#{name} - #{rating}"
  end

  def to_s
    "#{name} – #{[rating, watched_on].map(&:to_s).join(', ')}"
  end

private

  # Remove leading 'The' and 'A'.
  def assign_sort_name
    self.sort_name = name.sub /^(The|A|An)\s/, ''
  end

  def string_to_boolean(string)
    string.downcase == 'y' ? true : false
  end

end
