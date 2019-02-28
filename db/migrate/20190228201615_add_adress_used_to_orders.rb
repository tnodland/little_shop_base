class AddAdressUsedToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :user_address, :string
    add_column :orders, :user_state, :string
    add_column :orders, :user_city, :string
    add_column :orders, :user_zip, :integer
  end
end
