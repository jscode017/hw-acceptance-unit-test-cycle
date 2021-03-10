require 'rails_helper.rb'
RSpec.describe MoviesHelper, :type => :helper do
	describe '#oddness' do
		it 'should return odd if the number is odd' do
			expect(helper.oddness(-1)).to eq "odd"
			expect(helper.oddness(1)).to eq "odd"
		end
		it 'should return even if the number is even' do
			expect(helper.oddness(-2)).to eq "even"
			expect(helper.oddness(0)).to eq "even"
			expect(helper.oddness(2)).to eq "even"
		end
	end
end
 