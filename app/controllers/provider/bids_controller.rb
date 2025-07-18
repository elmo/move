class Provider::BidsController < ApplicationController
  include Pagy::Backend
  before_action :set_bid, only: [ :show, :confirm ]

  def index
    @bids = current_user.provider.bids.order(id: :desc)
    @pagy, @bids = pagy(@bids, items: 12)
  end

  def confirm
  @bid.confirm!
    redirect_to provider_bid_path(@bid), notice: "Bid has been confirmed" and return false
  end

  def show
    @rfp = @bid.rfp
  end

  def destroy
    @bid.destroy!
    redirect_to provider_bids_path, notice: "Bid retracted"
  end

  private

  def set_bid
    @bid = Bid.find_by!(slug: params[:id])
  end

end
