class ChangeStudentsTicketsDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:students, :tickets, 1)
  end
end
