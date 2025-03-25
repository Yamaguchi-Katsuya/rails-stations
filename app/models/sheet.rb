class Sheet < ApplicationRecord
  validates :column, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :row, presence: true, length: { is: 1 }
end
