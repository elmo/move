class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.string :sender_phone
      t.string :recipient_phone
      t.string :subject
      t.text :body
      t.string :slug
      t.string  :email_sending_status
      t.string  :sms_sending_status
      t.datetime :sms_sent_at
      t.datetime :email_sent_at
      t.datetime :sms_failed_at
      t.datetime :email_failed_at
      t.timestamps
    end

    add_index :messages, :email_sending_status
    add_index :messages, :sms_sending_status

  end
end
