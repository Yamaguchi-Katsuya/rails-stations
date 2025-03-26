class Screen < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
