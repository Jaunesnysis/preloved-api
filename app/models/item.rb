class Item < ApplicationRecord
  validates :title, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :condition, inclusion: { in: %w[new like_new good fair poor] }
  validates :status, inclusion: { in: %w[available sold reserved] }

  belongs_to :user
  belongs_to :category
  has_many :transactions
end