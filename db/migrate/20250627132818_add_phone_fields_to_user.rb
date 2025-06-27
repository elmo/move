class AddPhoneFieldsToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :phone, :string
    add_column :users, :allow_text_messages, :boolean
    add_column :users, :terms_accepted, :boolean
    add_column :users, :terms_accepted_at, :datetime
  end
end
