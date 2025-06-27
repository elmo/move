class Customer < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :customer_type, presence: true
  after_create :add_user_role

  def add_user_role
    user.add_role('customer')
  end

end
