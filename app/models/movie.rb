class Movie < ActiveRecord::Base
	def self.all_ratings
		return ['G','PG','PG-13','R']
	end

	def self.with_ratings(ratings, ordering)
		if ordering=='title' || ordering=='release_date'
		  return self.where({:rating => ratings}).order(ordering)
		else
		  return self.where({:rating => ratings})
		end
	end

end
