class Backend::BaseController < BaseController
  include RestfullyManageable
  before_action :authenticate_user!
  before_action :authorize_user!
  layout 'backend'

  attr_reader :current_participation, :current_participant

  protected

  def authorize_user!
    unless current_user.administrator?
      redirect_to root_url, alert: :access_denied.tl
      return false
    end
  end

end
