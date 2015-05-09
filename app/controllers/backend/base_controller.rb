class Backend::BaseController < BaseController
  include RestfullyManageable
  before_action :authenticate_user!
  layout "backend"
end
