require './moty'

Movie.unrated.each do |movie|
  print "#{movie.name}: "
  rating = gets.chomp
  if rating.present?
    movie.rate! rating
  end
end
