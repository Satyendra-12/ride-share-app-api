class Addcolumnstatustopassengers < ActiveRecord::Migration[7.0]
  def change
    add_column :passengers, :status, :string
  end
end
