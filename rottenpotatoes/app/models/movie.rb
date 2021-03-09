class Movie < ActiveRecord::Base
	def self.movies_with_same_director(director)
		return Movie.where(director:director)
	end
end
