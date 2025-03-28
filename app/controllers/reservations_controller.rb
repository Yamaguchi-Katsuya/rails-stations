class ReservationsController < ApplicationController
  before_action :set_movie
  before_action :set_schedule
  before_action :authenticate_user!

  def new
    if params[:sheet_id].blank? || params[:date].blank?
      redirect_to movie_reservation_path(@movie, schedule_id: @schedule.id, date: @date), alert: "座席と日付が必要です"
      return
    end
    @date = params[:date]
    set_sheet(params[:sheet_id])
    @reservation = Reservation.new
  end

  def create
    set_sheet(params["reservation"][:sheet_id])
    @date = params["reservation"][:date]
    @screen_id = Reservation.find_available_screen_or_full(@schedule.id, @sheet.id, @date)
    if @screen_id == false # false の場合は座席がすでに予約済み
      redirect_to movie_reservation_path(@movie, schedule_id: @schedule.id, date: @date), alert: "その座席はすでに予約済みです"
      return
    end
    @reservation = Reservation.new(reservation_params)
    @reservation.screen_id = @screen_id
    @reservation.user_id = current_user.id
    if @reservation.save
      redirect_to movie_path(@movie), notice: "予約が完了しました"
    else
      render :new
    end
  end

  private

  def set_movie
    movie_id = params[:movie_id] || params["reservation"][:movie_id]
    @movie = Movie.find(movie_id)
  rescue ActiveRecord::RecordNotFound
    redirect_to movies_path, alert: "映画が見つかりません"
  end

  def set_schedule
    schedule_id = params[:schedule_id] || params["reservation"][:schedule_id]
    @schedule = Schedule.find(schedule_id)
  rescue ActiveRecord::RecordNotFound
    redirect_to movies_path, alert: "上映スケジュールが見つかりません"
  end

  def set_sheet(sheet_id)
    @sheet = Sheet.find(sheet_id)
  rescue ActiveRecord::RecordNotFound
    redirect_to movies_path, alert: "座席が見つかりません"
  end

  def reservation_params
    params.require(:reservation).permit(:date, :schedule_id, :sheet_id)
  end

end
