class AddReservationTicketLog < ActiveRecord::Migration[6.1]
  def change
    add_column :reservations, :tickets_before, :integer
    add_column :reservations, :tickets_after, :integer
  end
end
