class CreateBids < ActiveRecord::Migration[8.0]
  def change
    create_table :bids do |t|
      t.integer :user_id
      t.integer :rfp_id
      t.integer :amount
      t.string :name
      t.string :status
      t.string :slug

      t.timestamps
    end
  end
end
