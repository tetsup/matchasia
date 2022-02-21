class AddStripeCustomerId < ActiveRecord::Migration[6.1]
  def change
    add_column :students, :stripe_customer_id, :text
  end
end
