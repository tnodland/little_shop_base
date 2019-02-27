class AddMoreColumnsToLocation < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :city, :string
    add_column :locations, :state, :string
    add_column :locations, :zip, :string
  end
end
