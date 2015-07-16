class ContractsController < BaseController
  before_action :find_records

  def show
  end

  def new

  end

  protected
  def find_records
    unless (@contrat = ContractNature.find_by(id: params[:id]))
      redirect_to params[:redirect] || {controller: :participants, action: :index}, alert: 'Contract not found'
    end
  end
end
