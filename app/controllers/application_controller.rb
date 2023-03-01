class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def user_admin
    return if current_user.admin?

    flash[:warning] = 'You have no access to users'
    redirect_to(item_advances_path)
  end

  def notice_message(message)
    controller = I18n.t "links.#{controller_name}"
    "#{controller.singularize} #{I18n.t message}"
  end
end
