class CreateJoinTableRfpUnloadingStairs < ActiveRecord::Migration[8.0]
  def change
    create_join_table :rfps, :unloading_stairs do |t|
       t.index [:rfp_id, :unloading_stair_id]
       t.index [:unloading_stair_id, :rfp_id]
    end
  end
end
