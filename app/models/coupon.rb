class Coupon < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'
  belongs_to :item, foreign_key: 'item_id'
  validates_presence_of :code, :modifier
end
