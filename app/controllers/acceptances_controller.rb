class AcceptancesController < ApplicationController
  layout "checkout"

  def new
    @bid = Bid.find_by(slug: params[:bid_id])
    @acceptance = Acceptance.new
    @acceptance.bid = @bid
    @amount = @bid.deposit_amount_for_stripe
  end

  def create_acceptance_payment_intent
    @bid = Bid.find_by(slug: params[:bid_id])
    @amount = @bid.deposit_amount_for_stripe
    begin
      currency = "usd" # Or your desired currency
      payment_intent = Stripe::PaymentIntent.create(
        amount: @amount,
        currency: currency,
        automatic_payment_methods: {
          enabled: true
        },
        customer: current_user.stripe_customer_id,
        metadata: { rfp: @bid.rfp.id, bid_id: @bid.id }
      )
      # Send the client_secret back to the frontend
      render json: { clientSecret: payment_intent.client_secret }
    rescue Stripe::StripeError => e
      render json: { error: { message: e.message } }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: { message: "An unexpected error occurred: #{e.message}" } }, status: :internal_server_error
    end
  end

  def confirm
    @payment_intent_id = params[:payment_intent]
    begin
      payment_intent = Stripe::PaymentIntent.retrieve(@payment_intent_id)
      @payment_status = payment_intent.status
      redirect_to rfps_path, notice: "Payment complete" if @payment_status == "succeeded"
    rescue Stripe::StripeError => e
      @payment_status = "Error: #{e.message}"
    end
  end

  private

  def acceptance_params
    params.require(:acceptance).permit(:bid_id)
  end
end
