class LoansController < BaseController

  def new
    @participant = Participant.find(params[:lender_id])

    @loan = Loan.new
    @loan.borrower = current_participant
    @loan.lender = @participant
  end

  def create
    @loan = Loan.new(loan_params)
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


  private
  def loan_params
    params.require(:loan).permit(:borrower_id, :lender_id, :amount, :turns_count, :interest_percentage, :insurance_percentage)
  end
end
