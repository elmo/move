class AddRadiusToProvider < ActiveRecord::Migration[8.0]
  def change
    add_column :providers, :radius, :integer, default: 100
  end
end
