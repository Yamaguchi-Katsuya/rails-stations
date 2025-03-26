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

  def reservation
    @movie = Movie.find(params[:id])
    @date = params[:date]

    # 必要なパラメータがあるかチェック
    if params[:schedule_id].blank? || params[:date].blank?
      redirect_to movie_path(@movie), alert: "スケジュールと日付が必要です"
      return
    end

    @schedule = @movie.schedules.find_by(id: params[:schedule_id])
    unless @schedule
      redirect_to movie_path(@movie), alert: "上映スケジュールが見つかりません"
      return
    end

    @unavailable_sheets = Reservation.unavailable_sheets(@schedule.id, @date)
    @sheets = Sheet.order(column: :asc, row: :asc)
    @sheetGroups = @sheets.group_by(&:row)

    render "movies/reservation"
  end
end
