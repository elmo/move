require 'httparty'
class RfpsController < ApplicationController
  include Pagy::Backend

  before_action :set_rfp, only: [ "show", "edit", "update", "destroy", "publish", "unpublish", "delete_attachment"]

  def index
    redirect_to edit_user_path and return false if current_user.roles.empty?
    if current_user.provider?
      @rfps = Rfp.published.near(current_user.provider.zip, current_user.provider.radius)
    else
      @rfps = current_user.rfps
    end

    @pagy, @rfps = pagy(@rfps, items: 12)
  end

  def choose
  end

  def new
    @rfp = params[:type].constantize.new(current_step: 1)
  end

  def create
    @rfp = rfp_params[:type].constantize.new(rfp_params)
    @rfp.user = current_user
    if @rfp.save
      redirect_to edit_rfp_path(@rfp.slug), notice: "Request was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    get_map_route
  end

  def edit
    @rfp.current_step = 2
  end

  def update
    if @rfp.update(rfp_params)
      redirect_to edit_rfp_path(@rfp.slug), notice: "Request was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def publish
    @rfp.publish!
    redirect_to edit_rfp_path(@rfp), notice: "Your job request has been published"
  end

  def unpublish
    @rfp.unpublish!
    redirect_to edit_rfp_path(@rfp), notice: "Your job request has been published"
  end

  def destroy
    @rfp.destroy
    redirect_to rfps_path, notice: "Request was successfully destroyed."
  end

  def delete_attachment
    attachment = @rfp.images.find(params[:attachment_id]) # For has_many_attached
    attachment.purge_later
    redirect_back(fallback_location: rfp_path(@rfp), notice: 'Attachment file deleted successfully.')
  end

  private

  def set_rfp
    @rfp = Rfp.find_by!(slug: params[:slug])
  end

  def rfp_params
    params.require(:rfp).permit(:move_date, :type, :move_type, :load_address, :unload_address, :number_of_movers_requested, :estimated_time_in_hours, :loading_stairs, :loading_floor, :loading_stairs_details, :unloading_stairs, :unloading_stairs_details, :unloading_floor, :specialty_items_details, :need_assistance_with_moving_supplies, :donation_junk_removal, :slug, :has_specialty_items, :loading_elevator, :unloading_elevator, :earliest_move_date, :move_finish_date, :current_step, :what_are_you_hauling, :hauling_notes, :hauling_distance_in_miles,  specialty_item_ids: [], loading_stair_ids: [], unloading_stair_ids: [], images: [])
  end
end
