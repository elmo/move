class RenameSpecialtyItems < ActiveRecord::Migration[8.0]
  def change
    rename_column :rfps, :specialty_items, :has_specialty_items
  end
end
