class Admin::SchedulesController < ApplicationController
  before_action :set_movie, only: [:new, :create]

  def index
    @movies = Movie.includes(:schedules).where.not(schedules: { id: nil })
  end

  def new
    @schedule = @movie.schedules.build
  end

  def create
    @schedule = @movie.schedules.build(schedule_params)
    if @schedule.save
      redirect_to admin_schedules_path, notice: "上映スケジュールを作成しました"
    else
      render :new
    end
  end

  def edit
    @schedule = Schedule.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_schedules_path, alert: "上映スケジュールが見つかりません"
  end

  def update
    @schedule = Schedule.find(params[:id])
    if @schedule.update(schedule_params)
      redirect_to admin_schedules_path, notice: "上映スケジュールを更新しました"
    else
      render :edit
    end
  end

  def destroy
    @schedule = Schedule.find(params[:id])
    @schedule.destroy
    redirect_to admin_schedules_path, notice: "上映スケジュールを削除しました"
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_schedules_path, alert: "上映スケジュールが見つかりません"
  end

  def unavailable_sheets
    logger.info("unavailable_sheets date: #{params[:date]}")
    unavailable_sheets = Reservation.unavailable_sheets(params[:schedule_id], params[:date])
    render json: unavailable_sheets
  end


  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_movies_path, alert: "映画が見つかりません"
  end

  def schedule_params
    params.require(:schedule).permit(:start_time, :end_time)
  end
end
