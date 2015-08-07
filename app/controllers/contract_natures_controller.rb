class ContractNaturesController < BaseController
  before_action :check_running_game
  before_action :find_resource

  def show
  end

  def new
  end

  protected

  def find_resource
    unless (@contract_nature = ContractNature.find_by(id: params[:id]))
      redirect_to params[:redirect] || root_url, alert: 'Contract nature not found'
    end
  end
end
