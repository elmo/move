class MovingRequest < Rfp
  validates :load_address, presence: true, if: -> { current_step.to_i > 1 }
  validates :move_date, presence: true, if: -> { current_step.to_i > 1 }
  validates :move_type, presence: true, if: -> { current_step.to_i > 1 }
  validates :load_address, presence: true, if: -> { current_step.to_i > 1 }
  validates :unload_address, presence: true, if: -> { current_step.to_i > 1 }
  validates :number_of_movers_requested, presence: true, if: -> { current_step.to_i > 1 }
  validates :loading_stairs, presence: true, if: -> { current_step.to_i > 1 }
  validates :loading_floor, presence: true, if: -> { current_step.to_i > 1 }
  validates :loading_elevator, presence: true, if: -> { current_step.to_i > 1 }
  validates :loading_stairs_details, presence: true, if: -> { current_step.to_i > 1 && loading_stairs == "Yes" }
  validates :unloading_floor, presence: true, if: -> { current_step.to_i > 1 }
  validates :unloading_elevator, presence: true, if: -> { current_step.to_i > 1 }
  validates :unloading_stairs_details, presence: true, if: -> { current_step.to_i > 1 && loading_stairs == "Yes" }
  validates :earliest_move_date, presence: true, if: -> { current_step.to_i > 1 }
  validates :move_finish_date, presence: true, if: -> { current_step.to_i > 1 }
  validates :specialty_items, presence: true, if: -> { current_step.to_i > 1 }
  validates :specialty_items, presence: true, if: -> { current_step.to_i > 1 }
  validates :specialty_items_details, presence: true, if: -> { current_step.to_i > 1 }
  validates :need_assistance_with_moving_supplies, presence: true, if: -> { current_step.to_i > 1 }
  validates :donation_junk_removal, presence: true, if: -> { current_step.to_i > 1 }

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
