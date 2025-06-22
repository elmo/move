class AddElevatorFieldsToRfp < ActiveRecord::Migration[8.0]
  def change
    add_column :rfps, :specialty_items, :string
    add_column :rfps, :loading_elevator, :string
    add_column :rfps, :unloading_elevator, :string
  end
end
