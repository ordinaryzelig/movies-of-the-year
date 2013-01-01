require_relative '../lib/date_extensions'
require_relative '../lib/ics/event'

class Movie < ActiveRecord::Base

  scope :unrated,               where(rating: nil)
  scope :rated,                 where('rating IS NOT NULL')
  scope :with_rating,           proc { |rating| where(rating: rating) }
  scope :best,                  with_rating(4..5)
  scope :worst,                 with_rating(1..2)
  scope :watched_before,        proc { |bool| where(watched_before: bool) }
  scope :without_release_dates, where(released_on: nil)

  # Order scopes.
  scope :by_name,   order(:sort_name)
  scope :by_rating, order(:rating)

  validates :rating, inclusion: {in: 1..5, allow_nil: true}

  class << self

    def new_from_event(event)
      new(
        event_summary:  event.summary,
        watched_on:     event.started_on.to_date,
      )
    end

    # Scope for year watched using date range.
    def watched_in(year)
      raise 'Missing year' if year.blank?
      date_range = Date.beginning_of_year(year.to_i)..Date.end_of_year(year.to_i)
      where(watched_on: date_range)
    end

    # Scope for year released using date range.
    def released_in(year)
      date_range = Date.beginning_of_year(year)..Date.end_of_year(year)
      where(released_on: date_range)
    end

    # Movies watched in same year they were released.
    def new_releases_in(year)
      released_in(year).watched_in(year)
    end

  end

  # Parse event summary with format: title (rating, watched_before),
  # assign to name, rating, watched_before.
  def event_summary=(string)
    match_data = string.match(%r{
      (?<name>.*)
      \(
        (?<rating>\d),
        \s*
        (?<watched_before>[ny]+)
      \)
    }x)

    self.name           = match_data[:name].strip
    self.rating         = match_data[:rating].to_i
    self.watched_before = match_data[:watched_before] == 'y' ? true : false
  end

  # Assign sort name after assigning name.
  def name=(string)
    super
    assign_sort_name
  end

  # Movie name and rating.
  def listing
    "#{self.name} (#{self.rating})"
  end

  private

  # Remove leading 'The' and 'A'.
  def assign_sort_name
    self.sort_name = name.sub /^The |^A |^An/, ''
  end

end
