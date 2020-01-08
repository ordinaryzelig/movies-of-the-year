require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  #t.libs << 'spec'
  t.pattern = 'spec/**/*_spec.rb'
end

task :environment do
  require_relative 'init'
end

desc 'Import from movies.ics'
task :import, [:year] do |t, args|
  require_relative 'script/import'
  Import.(Integer(args.year))
end

namespace :db do

  desc 'Clear data in db.'
  task :reset => :environment do
    DB.reset
  end

  namespace :test do

    desc 'Setup test db'
    task :prepare do
      ENV['MOTY_ENV'] = 'test'
      Rake::Task['environment'].invoke
      Rake::Task['db:reset'].invoke
    end

  end

end

desc 'List all stats'
task :stats, [:year] do |t, args|
  [
    'best_of',
    'worst_of',
    'watched_before_ratio',
    'list',
  ].each do |task|
    stats_task = "stats:#{task}"
    puts stats_task
    Rake::Task[stats_task].invoke(*args)
    puts
  end
end

namespace :stats do

  desc 'List movies.'
  task :list, [:year] => :environment do |t, args|
    movies = Movie.watched_in(Integer(args.year)).by_name
    puts "#{movies.size} movies"
    movies.group_by(&:name).each do |name, movies|
      print "#{movies.first.listing}"
      print " x #{movies.size}" if movies.size > 1
      puts
    end
  end

  desc 'List best of year.'
  task :best_of, [:year] => :environment do |t, args|
    best_or_worst :best, args.year
  end

  desc 'List worst of year.'
  task :worst_of, [:year] => :environment do |t, args|
    best_or_worst :worst, args.year
  end

  def best_or_worst(best_or_worst, year)
    movies =
      Movie
        .watched_before(false)
        .watched_in(Integer(year))
        .send(best_or_worst)
        .by_rating
        .by_name
    movies.each do |movie|
      puts movie.listing
    end
  end

  desc 'Count by grouping movies that I have watched before'
  task :watched_before_ratio, [:year] => :environment do |t, args|
    watched_before, new_movies = Movie.watched_in(Integer(args.year)).partition(&:watched_before)
    puts "watched before: #{watched_before.size}"
    puts "not watched before: #{new_movies.size}"
    puts "ratio: #{watched_before.size.to_f/new_movies.size.to_f}"
  end

end
