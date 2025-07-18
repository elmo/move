module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
    helper_method :impersonating?
    helper_method :impersonated_user
  end

  class_methods do
    def allow_unauthenticated_access(skip_resume_session: false, **options)
      skip_before_action :require_authentication, **options
      before_action :resume_session, **options unless skip_resume_session
    end
  end

  private
    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || request_authentication
    end

    def resume_session
      Current.impersonated_user = find_impersonated_user
      Current.session ||= find_session_by_cookie
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id])
    end


    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_session_path
    end

    def after_authentication_url
      if current_user.admin?
        starting_path = admin_users_path
      elsif current_user.customer?
        starting_path = rfps_path
      elsif current_user.provider?
        starting_path = provider_url(current_user.provider)
      else
        starting_path = root_path
      end
      session.delete(:return_to_after_authenticating) || starting_path
    end

    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      end
    end

    def terminate_session
      Current.session.destroy
      cookies.delete(:session_id)
      stop_impersonating
    end

    def impersonating?
      Current.impersonated_user.present?
    end

    def impersonate(user)
      Current.impersonated_user = user
      session[:impersonated_user_id] = user.id
    end

    def impersonated_user
      Current.impersonated_user
    end

    def find_impersonated_user
      if (id = session[:impersonated_user_id])
        User.find_by(id: id)
      end
    end

    def stop_impersonating
      Current.impersonated_user = nil
      session.delete(:impersonated_user_id)
    end
end
