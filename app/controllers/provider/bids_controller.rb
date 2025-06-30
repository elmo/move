class Provider::BidsController < ApplicationController
  include Pagy::Backend

  def index
    @bids = current_user.provider.bids.order(id: :desc)
    @pagy, @bids = pagy(@bids, items: 12)
  end

end
