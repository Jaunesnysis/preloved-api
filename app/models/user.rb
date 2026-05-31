class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  has_many :items, foreign_key: :user_id, dependent: :destroy
  has_many :transactions, foreign_key: :user_id
end