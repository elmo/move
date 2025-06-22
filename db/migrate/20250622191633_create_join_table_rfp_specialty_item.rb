class CreateJoinTableRfpSpecialtyItem < ActiveRecord::Migration[8.0]
  def change
    create_join_table :rfps, :specialty_items do |t|
       t.index [:rfp_id, :specialty_item_id]
       t.index [:specialty_item_id, :rfp_id]
    end
  end
end
