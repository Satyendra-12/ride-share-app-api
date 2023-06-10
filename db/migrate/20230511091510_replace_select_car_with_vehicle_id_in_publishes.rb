class ReplaceSelectCarWithVehicleIdInPublishes < ActiveRecord::Migration[7.0]
  def change
    # Add vehicle_id column
    add_column :publishes, :vehicle_id, :bigint

    # Create foreign key constraint
    add_foreign_key :publishes, :vehicles, on_delete: :cascade

    # Remove select_car column
    remove_column :publishes, :select_car, :string
  end
end
