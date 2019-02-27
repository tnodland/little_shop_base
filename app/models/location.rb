class Location < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'
  validates_presence_of :address
end
