class ContractsController < BaseController
  before_action :find_records

  def show
  end

  protected
  def find_records
    if (@participant = Participant.find(params[:id]))
      unless current_participant
        redirect_to params[:redirect] || {controller: :participants, action: :show, id: @participant.id}, alert: 'Cannot go to shop without participant'
      end
      @deal = Deal.find_or_create_by!(customer: current_participant, supplier: @participant, state: 'draft')
    else
      redirect_to params[:redirect] || {controller: :participants, action: :index}, alert: 'Participant not found'
    end
  end
end
