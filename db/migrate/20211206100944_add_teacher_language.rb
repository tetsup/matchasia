class AddTeacherLanguage < ActiveRecord::Migration[6.1]
  def change
    add_reference :teachers, :language
  end
end
