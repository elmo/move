class AddCurrentStepToRfp < ActiveRecord::Migration[8.0]
  def change
     add_column :rfps, :current_step, :integer, default: 0
  end
end
