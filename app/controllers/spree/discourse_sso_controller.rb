module Spree
  class DiscourseSsoController < Spree::StoreController
    def sso
      user = spree_current_user
      if user
        sso = SingleSignOn.parse(request.query_string)
        
        sso.email = user.email
        sso.username = user.login
        sso.external_id = user.id
    
        redirect_to sso.to_url
      else
        redirect_to login_path
      end
    end
  end
end