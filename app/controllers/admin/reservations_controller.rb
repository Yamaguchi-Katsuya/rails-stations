class Admin::ReservationsController < ApplicationController
  def index
    today = Date.today
    @reservations = Reservation
    .includes(:sheet, schedule: [:movie])
    .where("date >= ?", today)
    .where(schedules: { end_time: Time.now.. })
    .order(created_at: :desc)
  end

  def new
    @reservation = Reservation.new
    @sheets = Sheet.order(row: :asc, column: :asc)
    @movies = Movie.includes(:schedules).all
    @schedules = Schedule.all
  end

  def create
    @screen_id = Reservation.find_available_screen_or_full(params[:reservation][:schedule_id], params[:reservation][:sheet_id], params[:reservation][:date])
    if @screen_id == false # false の場合は座席がすでに予約済み
      redirect_to admin_reservations_path, alert: "その座席はすでに予約済みです"
      return
    end
    @reservation = Reservation.new(reservation_params)
    @reservation.screen_id = @screen_id
    if @reservation.save
      redirect_to admin_reservations_path, notice: "予約を作成しました"
    else
      render :new
    end
  end

  def show
    @reservation = Reservation.where(id: params[:id]).includes(:sheet, schedule: [:movie]).first
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_reservations_path, alert: "予約が見つかりません"
  end

  def edit
    @reservation = Reservation.where(id: params[:id]).includes(:sheet, schedule: [movie: [:schedules]]).first
    @unavailable_sheets = Reservation.unavailable_sheets(@reservation.schedule.id, @reservation.date)
    @sheets = Sheet.order(row: :asc, column: :asc)
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_reservations_path, alert: "予約が見つかりません"
  end

  def update
    @reservation = Reservation.find(params[:id])
    @screen_id = Reservation.find_available_screen_or_full(params[:reservation][:schedule_id], params[:reservation][:sheet_id], params[:reservation][:date])
    if @screen_id == false # false の場合は座席がすでに予約済み
      redirect_to admin_reservations_path, alert: "その座席はすでに予約済みです"
      return
    end
    if @reservation.update(reservation_params)
      redirect_to admin_reservations_path, notice: "予約を更新しました"
    else
      render :edit
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_reservations_path, alert: "予約が見つかりません"
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    if @reservation.destroy
      redirect_to admin_reservations_path, notice: "予約を削除しました"
    else
      redirect_to admin_reservations_path, alert: "予約の削除に失敗しました"
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_reservations_path, alert: "予約が見つかりません"
  end

  private

  def reservation_params
    params.require(:reservation).permit(:sheet_id, :date, :schedule_id, :email, :name)
  end
end
