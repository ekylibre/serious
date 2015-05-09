class Backend::BaseController < BaseController
  include RestfullyManageable
  before_action :authenticate_user!  
end
