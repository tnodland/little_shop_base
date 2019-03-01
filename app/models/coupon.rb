class Coupon < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'
  belongs_to :item, foreign_key: 'item_id'
  validates :code, presence: true, uniqueness: true
  validates_presence_of :modifier
end
