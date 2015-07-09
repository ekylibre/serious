class LoansController < BaseController
  layout 'loan'

  def new
    @participant = Participant.find(params[:lender_id])
    @current_participation = Participation.find_by(user_id: current_user.id)
    @current_participant = Participant.find(@current_participation.participant_id)
    #@current_participant = Participant.find(16)

    @loan = Loan.new
    @loan.borrower = @current_participant
    @loan.lender = @participant
  end

  def create
    @loan = Loan.new(loan_params)
    respond_to do |format|
      if @loan.save
        format.html { redirect_to @loan, notice: 'Loan was successfully created.' }
        format.json { render :show, status: :created, location: @loan }
      else
        format.html { render :new }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end


  private
  def loan_params
    params.require(:loan).permit(:borrower_id, :lender_id, :amount, :turns_count, :interest_percentage, :insurance_percentage)
  end
end
