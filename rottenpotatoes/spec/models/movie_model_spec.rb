require 'rails_helper.rb'
describe Movie do
	describe 'movies_with_same_director' do
		before (:each) do
			@movie1=FactoryBot.create(:movie, :title=>"first",:director=>"lucas")
			@movie2=FactoryBot.create(:movie, :title=>"second",:director=>"lucas")
			@movie3=FactoryBot.create(:movie, :title=>"third")
		end
		it 'return movies when calling with_same_director if director!=null' do		
				
			expect(Movie.movies_with_same_director(@movie1.director)).to eq([@movie1,@movie2])
		end
		it 'not movies when calling with_same_director if director==null' do		
				
			expect(Movie.movies_with_same_director(@movie3.director)).to eq(nil)
		end
	end
end