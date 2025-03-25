class MoviesController < ApplicationController
  def index
    @movies = Movie.all

    if params[:is_showing].present?
      is_showing = ActiveModel::Type::Boolean.new.cast(params[:is_showing])
      @movies = @movies.where(is_showing: is_showing)
    end

    if params[:keyword].present?
      @movies = @movies.search(params[:keyword])
    end

    render "movies/index"
  end

  def show
    @movie = Movie.find(params[:id])
    @schedules = @movie.schedules
    render "movies/show"
  end
end
