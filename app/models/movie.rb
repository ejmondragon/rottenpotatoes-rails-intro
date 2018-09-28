class Movie < ActiveRecord::Base
    
    def self.ratings
        result = []
        self.select(:rating).uniq.each do |movie|
            result << movie.rating
        end
        return result.sort
    end
    
end
