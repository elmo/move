class BidsController < ApplicationController
  include Pagy::Backend
  before_action :set_rfp
  before_action :set_bid, only: [ "show", "edit", "update", "destroy", "accept", "reject" ]
  before_action :subscription_required

  def index
    @bids = @rfp.bids.all
    @pagy, @bids = pagy(@bids, items: 12)
  end

  def new
    @bid = Bid.new
    @bid.name = "bid-#{@rfp.name}"
    get_map_route
  end

  def create
    @bid = @rfp.bids.new(bid_params)
    @bid.user = current_user
    @bid.provider = current_user.provider
    @bid.status = "new"
    if @bid.save
      redirect_to rfps_path, notice: "Your bid has been saved."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def accept
   @bid.accepted!
     redirect_to rfp_bid_path(@rfp, @bid), notice: "Bid has been accepted" and return false
  end

  def reject
   @bid.reject!
     redirect_to rfp_bid_path(@rfp, @bid), notice: "Bid has been rejected" and return false
  end

  def confirm
   @bid.confirm!
     redirect_to rfp_bid_path(@rfp, @bid), notice: "Bid has been confirmed" and return false
  end

  def show
    get_map_route
  end

  def edit
    get_map_route
  end

  def update
    if @bid.update(bid_params)
      redirect_to edit_rfp_bid_path(@rfp, @bid.slug), notice: "bid was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bid.destroy
    redirect_to rfp_bids_path(@rfp), notice: "bid was successfully destroyed." and return false
  end

  def remove_image
    @bid.image.purge
    redirect_to edit_bid_path(bid_slug: @bid.slug), notice: "Image removed successfully." and return false
  end

  private

  def subscription_required
    return true if !current_user.provider?
    return true if current_user.subscribed? 
    redirect_to plans_path, notice: "You need an active subscription to place a bid." and return false 
  end

  def set_rfp
    @rfp = Rfp.find_by!(slug: params[:rfp_slug])
  end

  def set_bid
    @bid = Bid.find_by!(slug: params[:bid_slug]) if params[:bid_slug].present?
    @bid = Bid.find_by!(slug: params[:slug]) if params[:slug].present?
  end

  def bid_params
    params.require(:bid).permit(:user_id, :rfp_id, :amount, :name, :status, :slug, :notes, :agree_to_platform_terms)
  end
end
