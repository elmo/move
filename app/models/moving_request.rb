class MovingRequest < Rfp
  def required_fields
    [
      :load_address,
      :move_date,
      :move_type,
      :load_address,
      :unload_address,
      :number_of_movers_requested,
      :loading_stairs,
      :loading_floor,
      :loading_elevator,
      :loading_stairs_details,
      :unloading_floor,
      :unloading_elevator,
      :unloading_stairs_details,
      :earliest_move_date,
      :move_finish_date,
      :specialty_items,
      :need_assistance_with_moving_supplies,
      :donation_junk_removal
    ]
  end
end
