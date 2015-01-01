require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'spec'
  t.pattern = 'spec/**/*_spec.rb'
end

# Connect to DB.
task :connect do
  require_relative 'db/db'
  DB.connect
end

task :models do
  require_relative 'models'
end

desc 'Fetch and assign release dates'
task :release_dates => :models do |t, args|
  require_relative 'lib/movie_data_fetcher'
  require 'awesome_print'

  Movie.without_release_dates.each do |movie|
    print movie.name
    tmdb_movies = MovieDataFetcher.search(movie.name)

    tmdb_movie = case tmdb_movies.size
    when 0
      # Nothing found, skip.
      puts " <not found>"
      next
    when 1
      # Only match, use this one.
      tmdb_movies.first
    else
      # Prompt for user input.
      prompted = true
      puts " (watched on #{movie.watched_on})"
      MovieDataFetcher.prompt(tmdb_movies)
    end

    next if tmdb_movie == :next

    if prompted
      print movie.name
    end

    movie.update_attribute :released_on, tmdb_movie.released
    puts " (#{movie.released_on})"
  end
end

namespace :db do

  task :require do
    require_relative 'db/db'
  end

  desc 'Clear data in db.'
  task :reset => :require do
    DB.reset
  end

  namespace :test do

    desc 'Setup test db'
    task :prepare do
      ENV['MOTY_ENV'] = 'test'
      Rake::Task['db:require'].invoke
      DB.schema
    end

  end

end

namespace :stats do

  desc 'List movies.'
  task :list, [:year] => :models do |t, args|
    movies = Movie.watched_in(args.year).by_name
    puts "#{movies.size} movies"
    movies.group_by(&:name).each do |name, movies|
      print "#{movies.first.listing}"
      print " x #{movies.size}" if movies.size > 1
      puts
    end
  end

  # List best/worst of movies that I haven't watched before.
  task :best_or_worst, [:best_or_worst, :year] => :models do |t, args|
    movies = Movie.watched_before(false).watched_in(args.year).send(args.best_or_worst).by_rating.by_name
    movies.each do |movie|
      puts movie.listing
    end
  end

  desc 'List best of year.'
  task :best_of, [:year] => :models do |t, args|
    Rake::Task[:'stats:best_or_worst'].invoke(:best, args.year)
  end

  desc 'List worst of year.'
  task :worst_of, [:year] => :models do |t, args|
    Rake::Task[:'stats:best_or_worst'].invoke(:worst, args.year)
  end

  desc 'Count by grouping movies that I have watched before'
  task :watched_before_ratio, [:year] => :models do |t, args|
    movies = Movie.watched_in(args.year).group_by(&:watched_before)
    puts "watched before: #{movies[true].size}"
    puts "not watched before: #{movies[false].size}"
    puts "ratio: #{movies[true].size.to_f/movies[false].size.to_f}"
  end

end
