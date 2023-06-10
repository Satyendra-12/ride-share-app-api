class CreatePublishes < ActiveRecord::Migration[7.0]
  def change
    create_table :publishes do |t|
      t.string :source
      t.string :destination
      t.integer :passengers_count
      t.string :add_city
      t.date :date
      t.time :time
      t.float :set_price
      t.text :about_ride
      t.references :user, null: false, foreign_key: { on_delete: :cascade }


      t.timestamps
    end
  end
end
