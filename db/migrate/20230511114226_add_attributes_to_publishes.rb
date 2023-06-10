class AddAttributesToPublishes < ActiveRecord::Migration[7.0]
  def change
    add_column :publishes, :book_instantly, :string
    add_column :publishes, :mid_seat, :string
    add_column :publishes, :select_route, :json
  end
end
