module UserHelper
  def social_network_link
    link_facebook = link_to user_facebook_omniauth_authorize_path,
      class: "btn btn-primary btn-block btn-social btn-facebook" do
      content_tag(:span, "", class: "fa fa-facebook") +
        t("users.sessions.new.sign_in_facebook")
    end
    link_google = link_to user_google_oauth2_omniauth_authorize_path,
      class: "btn btn-danger btn-block btn-social btn-google" do
      content_tag(:span, "", class: "fa fa-google-plus") +
        t("users.sessions.new.sign_in_google")
    end
    link_facebook + link_google
  end
end
