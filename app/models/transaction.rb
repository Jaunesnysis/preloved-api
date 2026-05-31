class Transaction < ApplicationRecord
  validates :amount, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[pending completed cancelled] }

  belongs_to :item
  belongs_to :user
end