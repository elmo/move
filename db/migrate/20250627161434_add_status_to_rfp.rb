class AddStatusToRfp < ActiveRecord::Migration[8.0]
  def change
    add_column :rfps, :status, :string, default: 'new'  
    add_index :rfps, :status
  end
end
