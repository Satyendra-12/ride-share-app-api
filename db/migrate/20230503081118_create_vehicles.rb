class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.string :country
      t.string :vehicle_number
      t.string :vehicle_brand
      t.string :vehicle_name
      t.string :vehicle_type
      t.string :vehicle_color
      t.integer :vehicle_model_year
      t.references :user, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
