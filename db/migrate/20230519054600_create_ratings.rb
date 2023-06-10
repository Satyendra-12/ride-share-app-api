class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings , force: :cascade do |t|
      t.integer :rating
      t.integer :rideid
      t.text :comment
      t.integer :giver
      t.integer :receiver

      t.timestamps
    end
  end
end