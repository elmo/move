class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  layout "authentication"

  def new
    @user = User.new
    @page_title = "Arrowline Moving - Sign up"
    redirect_to root_path if authenticated?
  end

  def create
    @page_title = "Arrowline Moving - Sign up"
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to after_authentication_url, notice: t("authentication.registrations.success_message", default: "Successfully signed up!")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address,
                                 :first_name,
                                 :last_name,
                                 :password,
                                 :password_confirmation,
                                 :role,
                                 :timezone)
  end
end
