class Reservation < ApplicationRecord
  belongs_to :schedule
  belongs_to :sheet

  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :name, presence: true, length: { maximum: 50 }
  validates :date, presence: true
  validates :schedule_id, presence: true
  validates :sheet_id, presence: true

  def self.is_reserved?(schedule_id, sheet_id, date)
    Reservation.exists?(schedule_id: schedule_id, sheet_id: sheet_id, date: date)
  end

  def self.reserved_sheets(schedule_id, date)
    Reservation.where(schedule_id: schedule_id, date: date).pluck(:sheet_id)
  end

end
