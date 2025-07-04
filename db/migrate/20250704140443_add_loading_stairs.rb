class AddLoadingStairs < ActiveRecord::Migration[8.0]
  def change
    create_table :loading_stairs do |t|
      t.string :name
    end

    create_table :unloading_stairs do |t|
      t.string :name
    end
  end
  remove_columns :rfps, :loading_stairs
  remove_columns :rfps, :loading_elevator
  remove_columns :rfps, :unloading_stairs
  remove_columns :rfps, :unloading_elevator
end
