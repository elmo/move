module ApplicationHelper
  include Pagy::Frontend

  include AvatarsHelper

  include FormsHelper

  include NavHelper

  def current_user
    Current.user
  end

  def move_type_options
    [
      "Load & Unload",
      "Load only",
      "Unload Load only",
      "In-Home Move / Rearraging",
      "Other"
    ]
  end

  def number_of_movers_options
    [ 2, 3, 4 ]
  end

  def number_of_hours_options
    [
      "Under 2 hours",
      "2-4 hours",
      "6+ hours",
      "Not sure"
    ]

   def specialty_items
     [
      'Safe',
      'Piano',
      'Pool Table',
      'Large Appliances',
      'Other'
     ]
   end
  end

  def loading_stairs_options
    [
      "Yes",
      "No",
      "Not sure"
    ]
  end

  def loading_floor_options
     1..15
  end

  def specialty_items_check_boxes
    [
      "Safe",
      "Piano",
      "Pool Table",
      "Large Appliances",
      "Other, (please describe)"
    ]
  end

  def yes_or_no_options
    [ "Yes", "No" ]
  end
end
