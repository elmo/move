class AddFurtherBidFields < ActiveRecord::Migration[8.0]
  def change
    add_column :bids, :agree_to_platform_terms, :boolean
    add_column :bids, :provider_id, :integer
    add_column :bids, :notes, :text
    add_index :bids, :provider_id
  end
end
