class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.references :student, foreign_key: true, null: false
      t.string :payment_intent, unique: true
      t.bigint :price_id, null: false
      t.integer :payment_phase, null: false, default: 0
      t.integer :tickets_before
      t.integer :tickets_after

      t.timestamps
    end
  end
end
