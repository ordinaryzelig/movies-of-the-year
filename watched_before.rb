require './moty'

Movie.where(:watched_before => nil).each do |movie|
  print "#{movie.name}: "
  bool = gets.chomp
  case bool
  when 'y'
    movie.watched_before = true
  when 'n'
    movie.watched_before = false
  end
  movie.save unless movie.watched_before.nil?
end
