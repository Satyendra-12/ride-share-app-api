class AddPriceAndSeatsToPassengers < ActiveRecord::Migration[7.0]
  def change
    add_column :passengers, :price, :float
    add_column :passengers, :seats, :integer
  end
end
