class CreateProviders < ActiveRecord::Migration[8.0]
  def change
    create_table :providers do |t|
      t.integer :user_id
      t.string :name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :license_number
      t.boolean :accept_provider_terms
      t.text :description
      t.string :slug

      t.timestamps
    end
  end
end
