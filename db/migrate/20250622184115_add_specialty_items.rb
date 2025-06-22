class AddSpecialtyItems < ActiveRecord::Migration[8.0]
  def change
    create_table :specialty_items do |t|
      t.integer :rfp_id
      t.string :name
    end

    [
     'Safe',
     'Piano',
     'Pool Table',
     'Large Appliances',
     'Other'
    ].each do |name|
      SpecialtyItem.create(name: name)
    end
  end

end
