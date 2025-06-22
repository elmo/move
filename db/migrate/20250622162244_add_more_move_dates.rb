class AddMoreMoveDates < ActiveRecord::Migration[8.0]
  def change
    add_column :rfps, :earliest_move_date, :date
    add_column :rfps, :move_finish_date, :date
  end
end
