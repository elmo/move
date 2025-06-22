class AddUnloadingStairsDetails < ActiveRecord::Migration[8.0]
  def change
    add_column :rfps, :unloading_stairs_details, :text
    add_column :rfps, :user_id, :integer
  end
end
