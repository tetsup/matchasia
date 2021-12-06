class AddTeachersAbout < ActiveRecord::Migration[6.1]
  def change
    add_column :teachers, :about, :text
  end
end
