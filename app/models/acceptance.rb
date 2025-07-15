class Acceptance < ApplicationRecord
  belongs_to :bid
  belongs_to :user

  after_create :save_bid_status

  private

  def save_bid_status
    bid.accepted!
  end
end
