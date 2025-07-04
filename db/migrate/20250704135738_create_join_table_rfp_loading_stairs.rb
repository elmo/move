class CreateJoinTableRfpLoadingStairs < ActiveRecord::Migration[8.0]
  def change
    create_join_table :rfps, :loading_stairs do |t|
       t.index [:rfp_id, :loading_stair_id]
       t.index [:loading_stair_id, :rfp_id]
    end
  end
end
