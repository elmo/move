class CreateRfps < ActiveRecord::Migration[8.0]
  def change
    create_table :rfps do |t|
      t.date :move_date
      t.string :type
      t.string :move_type
      t.string :load_address
      t.string :unload_address
      t.integer :number_of_movers_requested
      t.string :estimated_time_in_hours
      t.string :loading_stairs
      t.integer :loading_floor
      t.string :loading_stairs_details
      t.string :unloading_stairs
      t.integer :unloading_floor
      t.string :specialty_items_details
      t.string :need_assistance_with_moving_supplies
      t.string :donation_junk_removal
      t.string :slug
      t.timestamps
    end
  end
end
