class Ranking < ApplicationRecord
  validates :name, presence: true, length: { in: 1..8 }
end
