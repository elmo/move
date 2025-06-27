class CustomersController < ApplicationController
  

  before_action :set_customer, only: [ "show", "edit", "update", "destroy" ]

  def index
    @customers = Customer.all

    @customers = @customers
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = current_user.customers.new(customer_params)
    if @customer.save
      redirect_to new_rfp_path(type: @customer.customer_type), notice: "saved"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @customer.update(customer_params)
      redirect_to edit_customer_path(@customer), notice: "customer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy
    redirect_to customers_path, notice: "customer was successfully destroyed."
  end

  def remove_image
    @customer.image.purge
    redirect_to edit_customer_path(customer), notice: "Image removed successfully."
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:customer_type)
  end
end
