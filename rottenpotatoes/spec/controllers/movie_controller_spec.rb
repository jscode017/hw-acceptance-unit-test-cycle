require 'rails_helper.rb'
if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end

describe MoviesController do 
	before (:each) do
		@movie1=FactoryBot.create(:movie, :title=>"first",:director=>"lucas")
		@movie2=FactoryBot.create(:movie, :title=>"second",:director=>"lucas")
		@movie3=FactoryBot.create(:movie, :title=>"third")
	end
	describe '#with_same_director' do
		it 'return movies when calling with_same_director if director!=null' do
			
			
			get "with_same_director", {id:@movie1.id}
			
			expect(assigns[:movies]).to eq([@movie1,@movie2])
		end
		it 'redirect to homepage movies when calling with_same_director if director==null' do
			
			
			get "with_same_director", {id:@movie3.id}
			
			expect(response).to redirect_to(movies_path)
		end
	end

end