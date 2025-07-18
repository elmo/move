class MovingRequest < Rfp
  validates :load_address, presence: true, if: -> { current_step.to_i > 1 }
  validates :move_date, presence: true, if: -> { current_step.to_i > 1 }
  validates :move_type, presence: true, if: -> { current_step.to_i > 1 }
  validates :load_address, presence: true, if: -> { current_step.to_i > 1 }
  validates :unload_address, presence: true, if: -> { current_step.to_i > 1 }
  validates :number_of_movers_requested, presence: true, if: -> { current_step.to_i > 1 }
  validates :unloading_floor, presence: true, if: -> { current_step.to_i > 1 }
  validates :earliest_move_date, presence: true, if: -> { current_step.to_i > 1 }
  validates :move_finish_date, presence: true, if: -> { current_step.to_i > 1 }
  validates :specialty_items, presence: true, if: -> { current_step.to_i > 1 }
  validates :need_assistance_with_moving_supplies, presence: true, if: -> { current_step.to_i > 1 }
  validates :load_address, length: { is: 5 }, if: -> { current_step.to_i > 0 }
  validates :unload_address, length: { is: 5 }, if: -> { current_step.to_i > 1 }
  def required_fields
    [
      :load_address,
      :move_date,
      :move_type,
      :load_address,
      :unload_address,
      :number_of_movers_requested,
      :loading_floor,
      :unloading_floor,
      :earliest_move_date,
      :move_finish_date,
      :specialty_items,
      :need_assistance_with_moving_supplies,
      :donation_junk_removal
    ]
  end

  def long_name
    "#{load_address} -> #{unload_address}"
  end

end
