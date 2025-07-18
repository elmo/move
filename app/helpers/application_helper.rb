module ApplicationHelper
  include CommerceHelper

  include Pagy::Frontend

  include AvatarsHelper

  include FormsHelper

  include NavHelper

  def current_user
    Current.user
  end

  def customer_type_options
    [
      [ "Moving", "MovingRequest" ],
      [ "Hauling / Junk removal", "HaulingRequest" ]
    ]
  end

  def provider_type_options
    [
      "Moving",
      "Hauling",
      "Moving & Hauling"
    ]
  end

  def bid_statuses
    [
     "New",
     "Pending",
     "Accepted"
    ]
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

  def employee_type_options
    [
      "Employees",
      "Independent contractors"
    ]
  end

  def billing_style_options
    [
      "Hourly",
      "Weight",
      "Flat Fee"
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
      "Safe",
      "Piano",
      "Pool Table",
      "Large Appliances",
      "Other"
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

  def icon_for_job_type(type:)
    {
      "CourierRequest" => "car",
      "HaulingRequest" => "truck",
      "MovingRequest" => "box"
    }[type.to_s]
  end

  def current_account
    return @current_account if defined?(@current_account)

    if cookies[:current_account].present?
      account = Account.find_by(slug: cookies[:current_account])
      if account && account.users.include?(current_user)
        @current_account = account
      end
    end

    # Fallback: User's most recently created account
    @current_account = if current_user.present? && current_user.accounts.any?
                         current_user.accounts.order(created_at: :desc).first
    else
                         nil
    end
  end

   def qr_code_for_current_page
     url = request.original_url
     qr = RQRCode::QRCode.new(url)
     qr.as_png(size: 200, border_modules: 2).to_data_url
   end

   def qr_code_for_home_page
     qr = RQRCode::QRCode.new("https://arrowlinemoving.com")
     qr.as_png(size: 200, border_modules: 2).to_data_url
   end
  
end
