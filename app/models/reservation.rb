class Reservation < ApplicationRecord
  belongs_to :schedule
  belongs_to :sheet
  belongs_to :screen
  belongs_to :user

  validates :date, presence: true, uniqueness: { scope: [:schedule_id, :sheet_id, :screen_id] }
  validates :schedule_id, presence: true
  validates :sheet_id, presence: true
  validates :screen_id, presence: true
  validates :user_id, presence: true

  def self.is_reserved?(schedule_id, sheet_id, date)
    Reservation.exists?(schedule_id: schedule_id, sheet_id: sheet_id, date: date)
  end

  def self.find_available_screen_or_full(schedule_id, sheet_id, date)
    reservations = Reservation.where(schedule_id: schedule_id, sheet_id: sheet_id, date: date)
    reserved_count = reservations.size
    total_screens = Screen.count

    return false if reserved_count >= total_screens

    reserved_screen_ids = reservations.pluck(:screen_id)
    available_screens = Screen.where.not(id: reserved_screen_ids)
    return false if available_screens.empty?

    available_screens.sample.id
  end

  def self.reserved_sheets(schedule_id, date)
    Reservation.where(schedule_id: schedule_id, date: date).pluck(:sheet_id)
  end

  def self.unavailable_sheets(schedule_id, date)
    reserved_sheets = Reservation.where(schedule_id: schedule_id, date: date).group(:sheet_id).count
    total_screens = Screen.count
    reserved_sheet_ids = []
    reserved_sheets.each do |sheet_id, count|
      if count >= total_screens
        reserved_sheet_ids << sheet_id
      end
    end
    reserved_sheet_ids
  end
end
