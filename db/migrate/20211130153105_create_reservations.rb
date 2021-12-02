class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.references :lesson, foreign_key: true, null: false, unique: true
      t.references :student, foreign_key: true, null: false
      t.text :url, null: false, unique: true

      t.timestamps
    end
  end
end
