class Admin::MoviesController < ApplicationController
  def index
    @movies = Movie.all
    render "admin/movies/index"
  end

  def new
    @movie = Movie.new
    render "admin/movies/new"
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to admin_movies_path, notice: "映画を作成しました"
    else
      flash.now[:alert] = "映画の作成に失敗しました"
      render "admin/movies/new", status: :unprocessable_entity
    end
  end

  def edit
    @movie = Movie.find(params[:id])
    render "admin/movies/edit"
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
      redirect_to admin_movies_path, notice: "映画を更新しました"
    else
      flash.now[:alert] = "映画の更新に失敗しました"
      render "admin/movies/edit", status: :unprocessable_entity
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    if @movie.nil?
      flash.now[:alert] = "映画が見つかりません"
      render "admin/movies/edit", status: ActiveRecord::RecordNotFound
      return
    end

    begin
      @movie.destroy
        redirect_to admin_movies_path, notice: "映画を削除しました"
    rescue => e
      flash.now[:alert] = "映画の削除に失敗しました"
      render "admin/movies/edit", status: :unprocessable_entity
    end
  end

  private

  def movie_params
    params.require(:movie).permit(:name, :year, :description, :image_url, :is_showing)
  end
end
