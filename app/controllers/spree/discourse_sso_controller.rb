module Spree
  class DiscourseSsoController < Spree::StoreController
    def sso
      redirect_to login_path unless spree_current_user
      
      sso = SingleSignOn.parse(request.query_string)
      
      user = spree_current_user
      sso.email = user.email
      sso.username = user.login
      sso.external_id = user.id
  
      redirect_to sso.to_url
    end
  end
end