class ApplicationController < ActionController::Base
  include Authentication
  include ApplicationHelper

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern


  def authorize_admin_user
    unless current_user&.admin? || impersonating?
      redirect_to root_path, alert: t("admin.common.unauthorized", default: "You are not authorized to access this page.")
    end
  end

end
