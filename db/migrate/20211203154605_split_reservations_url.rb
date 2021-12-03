class SplitReservationsUrl < ActiveRecord::Migration[6.1]
  def change
    Reservation.delete_all
    rename_column :reservations, :url, :join_url
    add_column :reservations, :start_url, :text, null: false, unique: true
  end
end
