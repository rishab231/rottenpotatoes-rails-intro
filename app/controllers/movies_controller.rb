class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@all_ratings = Hash[Movie.all_ratings.collect { |v| [v, 1] }]
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings]
    @sorted = params[:sorted]

    # Redirect case - either selected_ratings or sorted is nil
    if @selected_ratings.nil? || @sorted.nil?
      # If @selected_ratings is nil
      if @selected_ratings.nil?
        if session[:ratings].nil?
          @selected_ratings = Hash[@all_ratings.collect { |v| [v, 1] }]
        else
          @selected_ratings = session[:ratings]
        end
      else
        # If @sorted is nil
        if session[:sorted].nil?
          @sorted = 'unsorted'
        else
          @sorted = session[:sorted]
        end
      end
      flash.keep
      redirect_to :ratings => @selected_ratings, :sorted => @sorted
    end

    session[:ratings] = params[:ratings]

    if params[:sorted]=='title'
      session[:sorted]='title'
      @title_color = 'hilite'
      @movies = Movie.with_ratings(@selected_ratings.keys, 'title')
    elsif params[:sorted]=='release_date'
      if params[:ratings].nil?
      end
      session[:sorted]='release_date'
      @release_color = 'hilite'
      @movies = Movie.with_ratings(@selected_ratings.keys, 'release_date')
    else
      session[:sorted] = 'unsorted'
      @movies = Movie.with_ratings(@selected_ratings.keys, 'unsorted')
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

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
