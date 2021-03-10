class Movie < ActiveRecord::Base
	def self.movies_with_same_director(director)
		if director=='' || director==nil
			return
		end
		return Movie.where(director:director)
	end
end
