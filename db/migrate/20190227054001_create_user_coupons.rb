class CreateUserCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :user_coupons do |t|
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true
      t.boolean :used, default: true
    end
  end
end
