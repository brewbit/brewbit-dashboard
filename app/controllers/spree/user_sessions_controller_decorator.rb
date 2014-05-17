Spree::UserSessionsController.class_eval do
  def after_sign_in_path_for(user)
    if user.has_spree_role? 'admin'
      '/admin'
    else
      '/dashboard'
    end
  end
end
