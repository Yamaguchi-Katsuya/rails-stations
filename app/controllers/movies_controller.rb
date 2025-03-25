class MoviesController < ApplicationController
  def index
    @movies = Movie.all

    if params[:is_showing].present?
      is_showing = ActiveModel::Type::Boolean.new.cast(params[:is_showing])
      @movies = @movies.where(is_showing: is_showing)
    end

    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"
      @movies = @movies.where("name LIKE ? OR description LIKE ?", keyword, keyword)
    end

    render "movies/index"
  end
end
