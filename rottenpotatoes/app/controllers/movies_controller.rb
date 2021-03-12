class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings=Movie.all_ratings
    if !params.include?(:notFirst)
      session.clear
    end
    if !params.include?(:ratings) && !session.include?(:ratings)
      @movies=Movie.all
      @ratings_to_show=[]
      session[:ratings]=Hash.new
    elsif params.include?(:ratings)
      @ratings_to_show=params[:ratings].keys
      if @ratings_to_show.length==0
        @rating_to_show=[]
      end
      @movies=Movie.with_ratings(@ratings_to_show)
      session[:ratings]=params[:ratings]
    elsif params.include?(:commit)
      @movies=Movie.all
      @ratings_to_show=[]
      session[:ratings]=Hash.new
    elsif 
      @ratings_to_show=session[:ratings].keys
      if @ratings_to_show.length==0
        @rating_to_show=[]
      end
      @movies=Movie.with_ratings(@ratings_to_show)
    end
    @sort_by=''
    if params.include?(:sort_by)
      @sort_by=params[:sort_by]
      session[:sort_by]=params[:sort_by]
    elsif session.include?(:sort_by)
      @sort_by=session[:sort_by]
    end
    
    if @sort_by=='title'
      @movies=@movies.order('title')
    elsif @sort_by=='release_date'
      @movies=@movies.order('release_date')
    end   
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end
  def with_same_director
    movie=Movie.find(params[:id])
    director=movie.director
    if director=='' || director==nil
      flash[:notice]="'#{movie.title}' has no director info"
      redirect_to movies_path
    end
    @movies=Movie.movies_with_same_director(director)
    
  end
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :director,:rating, :description, :release_date)
  end
end
