class Addcolumnstatustopublishes < ActiveRecord::Migration[7.0]
  def change
    add_column :publishes, :status, :string
  end
end
