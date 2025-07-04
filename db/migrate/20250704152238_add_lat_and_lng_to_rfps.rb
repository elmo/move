class AddLatAndLngToRfps < ActiveRecord::Migration[8.0]
  def change
    add_column :rfps, :latitude, :float
    add_column :rfps, :longitude, :float
    add_column :rfps, :unload_latitude, :float
    add_column :rfps, :unload_longitude, :float
    add_column :rfps, :move_distance, :integer
  end
end
