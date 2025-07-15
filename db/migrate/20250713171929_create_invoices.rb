class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.integer :user_id
      t.integer :bid_id
      t.float :amount, precision: 2
      t.string :name
      t.text :description
      t.string :stripe_customer_id
      t.string :slug
      t.string :status
      t.timestamps
    end
  end
end
