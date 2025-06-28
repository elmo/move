class CustomersController < ApplicationController
  def new
    @customer = Customer.new(customer_type: 'provider' )
  end

  def create
    @customer = current_user.customers.new(customer_params)
    if @customer.save
      if @customer.customer_type == 'customer'
        redirect_to new_rfp_path(type: @customer.customer_type), notice: "saved"
      else
        redirect_to new_provider_path, notice: "saved"
      end 
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:customer_type)
  end
end
