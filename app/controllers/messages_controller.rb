class MessagesController < ApplicationController
  include Pagy::Backend

  before_action :set_message, only: [ "show", "edit", "update", "destroy" ]

  def index
    @messages = Message.all

    @pagy, @messages = pagy(@messages, items: 12)
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to edit_message_path(@message.slug), notice: "message was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @message.update(message_params)
      redirect_to edit_message_path(@message.slug), notice: "message was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @message.destroy
    redirect_to messages_path, notice: "message was successfully destroyed."
  end

  def remove_image
    @message.image.purge
    redirect_to edit_message_path(message_slug: @message.slug), notice: "Image removed successfully."
  end

  private

  def set_message
    @message = Message.find_by!(slug: params[:slug])
  end

  def message_params
    params.require(:message).permit(:sender_id, :recipient_id, :sender_phone, :recipient_phone, :subject, :body, :slug)
  end
end
