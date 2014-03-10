Spree::UserSessionsController.class_eval do
  def after_sign_in_path_for(user)
    '/dashboard'
  end
end
