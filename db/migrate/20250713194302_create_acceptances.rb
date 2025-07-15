class CreateAcceptances < ActiveRecord::Migration[8.0]
  def change
    create_table :acceptances do |t|
      t.integer :user_id
      t.integer :bid_id
      t.datetime :paid_at

      t.timestamps
    end
  end
end
