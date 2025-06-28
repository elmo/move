class AddStatusFieldsToProvider < ActiveRecord::Migration[8.0]
  def change
    add_column :providers, :status, :string, default: 'new'
    add_column :providers, :applied_at, :dateime
    add_index :providers, :status
  end
end
