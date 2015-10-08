class ContractsController < BaseController
  before_action :check_running_game
  before_action :find_resource, only: [:show, :execute, :cancel]

  def show
  end

  def new
    contractor = Participant.find(params[:contractor_id])
    subcontractor = Participant.find(params[:subcontractor_id])
    @contract = Contract.new(contractor: contractor, subcontractor: subcontractor)
  end

  def create
    @contract = Contract.new(permitted_params)
    @contract.game = current_game
    participant = Participant.find(@contract.contractor_id)
    respond_to do |format|
      if @contract.save!
        format.html { redirect_to participant, notice: 'Contract was successfully created.' }
        format.json { render :show, status: :created, location: @contract }
      else
        format.html { render :new }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  def execute
    if request.post? && params[:rating]
      @contract.quality_rating = params[:rating]
      @contract.state = :executed
      @contract.save!
      redirect_to params[:redirect] || contract_path(@contract), alert: 'Contract not found'
    end
  end

  def cancel
    if request.post?
      @contract.state = :cancelled
      @contract.save!
    end
    redirect_to params[:redirect] || contract_path(@contract), alert: 'Contract not found'
  end

  protected

  def permitted_params
    params.require(:contract).permit(:subcontractor_id, :contractor_id, :name, :variant, :quantity, :delay, :conditions)
  end

  def find_resource
    @contract = Contract.find_by(id: params[:id])
    unless @contract
      redirect_to params[:redirect] || root_url, alert: 'Contract not found'
    end
  end
end
