class Schedule < ApplicationRecord
  belongs_to :movie
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :start_time_must_be_before_end_time

  private

  def start_time_must_be_before_end_time
    if start_time >= end_time
      errors.add(:start_time, "は上映終了時刻より前にしてください")
    end
  end
end
