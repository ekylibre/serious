class LoansController < BaseController
  before_action :check_running_game

  def new
    @participant = Participant.find(params[:lender_id])
    @loan = Loan.new(interest_percentage: 3, insurance_percentage: 0.3)
    @loan.borrower = current_participant
    @loan.lender = @participant
  end

  def create
    @loan = Loan.new(permitted_params)
    @participant = Participant.find(@loan.lender_id)
    respond_to do |format|
      if @loan.save
        format.html { redirect_to @participant, notice: 'Loan was successfully created.' }
        format.json { render :show, status: :created, location: @loan }
      else
        format.html { render :new }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  private

  def permitted_params
    params.require(:loan).permit(:borrower_id, :lender_id, :amount, :turns_count, :interest_percentage, :insurance_percentage)
  end
end
