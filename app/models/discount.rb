class Discount < ApplicationRecord
  belongs_to :merchant

  validates :percent, presence: true, numericality: { greater_than: 0 } 
  validates :quantity_threshold, numericality: true, presence: true

end
