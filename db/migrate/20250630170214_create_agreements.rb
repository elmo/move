class CreateAgreements < ActiveRecord::Migration[8.0]
  def change
    create_table :agreements do |t|
      t.integer :user_id
      t.integer :provider_id
      t.string :provider_company_name
      t.string :provider_company_signature
      t.datetime :provider_company_signed_date
      t.string :provider_user_name
      t.string :provider_user_signature
      t.datetime :provider_user_signed_date
      t.string :slug

      t.timestamps
    end
  end
end
