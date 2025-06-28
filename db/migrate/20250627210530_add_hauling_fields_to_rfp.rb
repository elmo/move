class AddHaulingFieldsToRfp < ActiveRecord::Migration[8.0]
  def change
    add_column :rfps, :what_are_you_hauling, :string
    add_column :rfps, :hauling_notes, :text
    add_column :rfps, :hauling_distance_in_miles, :integer  
  end
end
