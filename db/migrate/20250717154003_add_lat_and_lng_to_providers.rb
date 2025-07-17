class AddLatAndLngToProviders < ActiveRecord::Migration[8.0]
  def change
    add_column :providers, :latitude, :float
    add_column :providers, :longitude, :float
  end
end
