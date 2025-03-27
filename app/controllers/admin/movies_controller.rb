class Admin::MoviesController < Admin::BaseController
  def index
    @movies = Movie.all
  end

  def new
    @movie = Movie.new
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

  def show
    @movie = Movie.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_movies_path, alert: "映画が見つかりません"
  end

  def edit
    @movie = Movie.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_movies_path, alert: "映画が見つかりません"
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

  def schedules
    movie = Movie.includes(:schedules).find(params[:movie_id])
    schedules = movie.schedules.map { |s| { id: s.id, time: "#{s.start_time.strftime("%H:%M")} - #{s.end_time.strftime("%H:%M")}" } }
    render json: schedules
  end

  private

  def movie_params
    params.require(:movie).permit(:name, :year, :description, :image_url, :is_showing)
  end
end
