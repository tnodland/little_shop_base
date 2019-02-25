class CreatesCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :code
      t.float :modifier
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true
    end
  end
end
