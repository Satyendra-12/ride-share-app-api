class Renamecolumnofpublishes < ActiveRecord::Migration[7.0]
  def change
    rename_column :publishes, :user_id, :driver_id
  end
end
