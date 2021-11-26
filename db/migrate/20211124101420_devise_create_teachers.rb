# frozen_string_literal: true

class DeviseCreateTeachers < ActiveRecord::Migration[6.1]
  def change
    create_table :teachers do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :username,           null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      t.timestamps null: false
    end

    add_index :teachers, :email,                unique: true
    add_index :teachers, :reset_password_token, unique: true
    add_index :teachers, :confirmation_token,   unique: true
  end
end
