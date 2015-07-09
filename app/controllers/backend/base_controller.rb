class Backend::BaseController < BaseController
  include RestfullyManageable
  before_action :authenticate_user!
  before_action :authorize_user!
  layout 'backend'

  protected

  def authorize_user!
    unless current_user.administrator?
      redirect_to root_url, alert: :access_denied.tl
      return false
    end
  end

end
