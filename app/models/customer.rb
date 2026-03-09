class Customer < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :customer_type, presence: true
  TYPE_CUSTOMER = 'customer'
  TYPE_PROVIDER = 'provider'
end
