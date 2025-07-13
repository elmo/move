class ApplicationController < ActionController::Base
  include Authentication
  include ApplicationHelper

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern


  def authorize_admin_user
    unless current_user&.admin? || impersonating?
      redirect_to root_path, alert: t("admin.common.unauthorized", default: "You are not authorized to access this page.")
    end
  end

  def authorize_account_admin_user
    return unless @account.present?

    unless current_user.account_admin?(@account)
      redirect_to root_path, alert: t("teams.authorization.not_authorized", default: "You are not authorized to access this page.")
    end
  end

  def authorize_account_user
    return unless @account.present?

    unless current_user.account_user?(@account)
      redirect_to root_path, alert: t("teams.authorization.not_authorized", default: "You are not authorized to access this page.")
    end
  end

  def get_map_route
    if session[:route].blank?
      coordinates = "#{@rfp.longitude},#{@rfp.latitude};#{@rfp.unload_longitude},#{@rfp.unload_latitude}"
      access_token = Rails.application.credentials.dig(:mapbox, :token)
      url ="https://api.mapbox.com/directions/v5/mapbox/driving/#{coordinates}?access_token=#{access_token}"
      response = HTTParty.get(url)
      @route = response.parsed_response['routes'][0]['geometry'] if response.success?
      session[:route] = @route
    end
    @route = session[:route]
  end

end
