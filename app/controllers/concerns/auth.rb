module Auth

  def current_user
    @current_user ||= User.find_by(auth_token: request.headers["Authorization"])
  end

  def current_company
    @current_company ||= Company.find_by(subdomain: subdomain)
  end

  def require_company!
    render json: { errors: "Unspecified company" }, status: :unauthorized unless current_company.present?
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated" }, status: :unauthorized unless valid_user_signed_in?
  end

  def valid_user_signed_in?
    current_user.present? && current_company.present? && current_user.company == current_company
  end

  def subdomain
    # here we parse domain and check if it is ourcompany.theirs.com or theircompany.ours.com
    # I use a gem due to funkiness around TLDs of various lengths
    # domain is currently hardcoded for our production app to have name 'change-me', and local to use lvh.me
    host = PublicSuffix.parse(request.host)
    if host.sld == "change-me" || host.sld == "lvh"
      @subdomain = host.trd
    else
      @subdomain = host.sld
    end
  end
end
