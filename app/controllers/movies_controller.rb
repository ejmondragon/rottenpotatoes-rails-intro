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
    
    if(!params.has_key?(:sort) && !params.has_key?(:ratings))
      if(session.has_key?(:sort) || session.has_key?(:ratings))
        redirect_to movies_path(:sort=>session[:sort], :ratings=>session[:ratings])
      end
    end
    
    if params[:sort] != nil
      session[:sort] = params[:sort]
    end
    
    @all_ratings = Movie.ratings
    @selected_ratings = {}
    if params[:ratings] != nil
      params[:ratings].each { |rating|
        @selected_ratings[rating] = 1
      }
      session[:ratings] = @selected_ratings
    else
      session[:ratings].each { |rating|
        @selected_ratings[rating] = 1
      }
    end
    
    if !@selected_ratings.empty?
      @movies = Movie.where(rating: @selected_ratings.keys)
      session[:ratings] = @selected_ratings.keys
      @checked = @selected_ratings.keys
    elsif session[:ratings] == nil && params[:ratings] == nil
      @movies = Movie.all
      @checked = @all_ratings
    else
      @movies = Movie.all
      session[:ratings] = @all_ratings
      @checked = @all_ratings
    end
    
    
    if params[:sort] == 'title'
      @title_header = 'hilite'
      @movies = @movies.sort{|m1, m2| m1.title <=> m2.title}
    elsif params[:sort] == 'release_date'
      @release_date_header = 'hilite'
      @movies = @movies.sort{|m1, m2| m1.release_date <=> m2.release_date}
    else
      @title_header = ''
      @release_date_header = ''
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
