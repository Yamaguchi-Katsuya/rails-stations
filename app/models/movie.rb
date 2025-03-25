class Movie < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :year, presence: true
  validates :description, presence: true
  validates :image_url, presence: true
  validates :is_showing, inclusion: { in: [true, false] }
  has_many :schedules, dependent: :destroy

  def self.search(keyword)
    where("name LIKE ? OR description LIKE ?", "%#{keyword}%", "%#{keyword}%")
  end
end
