class CreateLessons < ActiveRecord::Migration[6.1]
  def change
    create_table :lessons do |t|
      t.references :teacher, foreign_key: true, null: false
      t.datetime :start_time, null: false
      t.references :language, null: false

      t.timestamps
    end

    add_index :lessons, [:teacher_id, :start_time], unique: true
  end
end
