class InvoicesController < ApplicationController
  include Pagy::Backend

  before_action :set_invoice, only: [ "show", "edit", "update", "destroy" ]

  def index
    @invoices = current_user.invoices.all
    @pagy, @invoices = pagy(@invoices, items: 12)
  end

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(invoice_params)
    if @invoice.save
      redirect_to edit_invoice_path(@invoice.slug), notice: "invoice was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to edit_invoice_path(@invoice.slug), notice: "invoice was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @invoice.destroy
    redirect_to invoices_path, notice: "invoice was successfully destroyed."
  end

  def remove_image
    @invoice.image.purge
    redirect_to edit_invoice_path(invoice_slug: @invoice.slug), notice: "Image removed successfully."
  end

  private

  def set_invoice
    @invoice = Invoice.find_by!(slug: params[:slug])
  end

  def invoice_params
    params.require(:invoice).permit(:user_id, :amount, :name, :description, :stripe_customer_id, :slug)
  end
end
