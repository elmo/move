class HaulingRequest < Rfp
  validates :load_address, presence: true, if: -> { current_step.to_i > 0 }
  validates :move_date, presence: true, if: -> { current_step.to_i > 0 }
  validates :what_are_you_hauling, presence: true, if: -> { current_step.to_i > 0 }
  #validates :hauling_distance_in_miles, presence: true, if: -> { current_step.to_i > 1 }
  #validates :hauling_notes, presence: true, if: -> { current_step.to_i > 1 }

  def required_fields
    [
      :load_address,
      :move_date,
      :what_are_you_hauling
      ]
   end

  def long_name
    "#{load_address}"
  end

end

