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
	
	describe '#with_same_director' do
		before (:each) do
			@movie1=FactoryBot.create(:movie, :title=>"first",:director=>"lucas")
			@movie2=FactoryBot.create(:movie, :title=>"second",:director=>"lucas")
			@movie3=FactoryBot.create(:movie, :title=>"third")
		end
		it 'return movies when calling with_same_director if director!=null' do
			
			
			get "with_same_director", {id:@movie1.id}
			
			expect(assigns[:movies]).to eq([@movie1,@movie2])
		end
		it 'redirect to homepage movies when calling with_same_director if director==null' do
			
			
			get "with_same_director", {id:@movie3.id}
			
			expect(response).to redirect_to(movies_path)
		end
	end
	describe '#index' do
		before (:each) do
			@movie1=FactoryBot.create(:movie, :title=>"first",:director=>"lucas")
			@movie2=FactoryBot.create(:movie, :title=>"second",:director=>"lucas")
			@movie3=FactoryBot.create(:movie, :title=>"third")
		end
		it 'should return all movies' do
			get :index
			expect(assigns[:movies]).to eq(Movie.all)
			expect(response).to render_template("index")
		end
	end

	describe '#find' do
		before (:each) do
			@movie1=FactoryBot.create(:movie, :title=>"first",:director=>"lucas")
		end
		it 'should return movie with correct id' do
			get :show, {id:@movie1.id}
			expect(response).to render_template("show")
			expect(assigns[:movie]).to eq(@movie1)
		end
	end

	describe '#new' do
		it 'should render new' do
			get :new
			expect(response).to render_template('new')
		end
	end
	describe '#create' do

		before (:each) do
			@movie4=FactoryBot.create(:movie, :title=>"fourth",:director=>'do not care',:rating=>'PG', :description=>'no description yet')
		end
		it 'should create the movie, return correct flash message, and redirect to homepage' do
			@movie_param={title: @movie4.title, director: @movie4.director,rating: @movie4.rating, description: @movie4.description, release_date: @movie4.release_date}
			post :create, {id:@movie4.id,movie:@movie_param}
			expect(flash[:notice]).to eq("#{@movie4.title} was successfully created.")
			expect(response).to redirect_to(movies_path)
		end
	end

	describe '#update' do
		before (:each) do
			@movie5=FactoryBot.create(:movie, :title=>"fifth",:director=>'do not care',:rating=>'PG', :description=>'no description yet')
		end
		it "should update the movie, return correct flash message, and redirect to selected movie's page" do
			@movie_param={title: @movie5.title, director: @movie5.director,rating: @movie5.rating, description: "new description", release_date: @movie5.release_date}
			post :update, {id:@movie5.id,movie:@movie_param}
			expect(flash[:notice]).to eq("#{@movie5.title} was successfully updated.")
			expect(response).to redirect_to(movie_path(@movie5))
		end
	end
	describe '#edit' do
		before (:each) do
			@movie6=FactoryBot.create(:movie, :title=>"sixth",:director=>'do not care',:rating=>'PG', :description=>'no description yet')
		end
		it 'should find and go to edit page of selected movie' do
			get :edit, {id:@movie6.id}
			expect(response).to render_template('edit')
			expect(assigns[:movie]).to eq(@movie6)
		end
	end
	describe '#destroy' do
		before (:each) do
			@movie7=FactoryBot.create(:movie, :title=>"seventh",:director=>'do not care',:rating=>'PG', :description=>'no description yet')
			@movies_before_destroy=Movie.all
			@movie_count_before_destroy=@movies_before_destroy.count
		end
		it 'should destroy the movie, and return correct flash message, and redirect to homepage' do
			post :destroy, {id:@movie7.id}
			@movies_after_destroy=Movie.all
			@movie_count_after_destroy=@movies_after_destroy.count
			expect(@movie_count_before_destroy).to eq(@movie_count_after_destroy+1)
			expect(flash[:notice]).to eq("Movie '#{@movie7.title}' deleted.")
			expect(response).to redirect_to(movies_path)
		end
	end
end