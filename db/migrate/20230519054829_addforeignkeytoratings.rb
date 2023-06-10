class Addforeignkeytoratings < ActiveRecord::Migration[7.0]
  
    def change
      add_foreign_key :ratings, :publishes, column: :rideid, on_delete: :cascade
      add_foreign_key :ratings, :users, column: :giver, on_delete: :cascade
      add_foreign_key :ratings, :users, column: :receiver, on_delete: :cascade
      
      change_column_null :ratings, :rideid, false
      change_column_null :ratings, :giver, false
      change_column_null :ratings, :receiver, false
    end
  end
