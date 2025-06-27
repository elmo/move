class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.integer :user_id
      t.string :customer_type
      t.timestamps
    end
  end
end
