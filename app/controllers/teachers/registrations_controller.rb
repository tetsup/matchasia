# frozen_string_literal: true

class Teachers::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_admin_in_devise!, only: [:new, :create]
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  private

  def authenticate_admin_in_devise!
    warden.authenticate!(scope: :admin)
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
