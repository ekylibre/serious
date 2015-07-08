class LoansController < BaseController
  before_action 'init'
  layout 'loan'

  def new
    @loan = Loan.new
    @loan.borrower = @current_participant
    @loan.lender = @participant
    puts @loan.inspect
    #redirect_to action: :show, id: params[:id]
  end

  protected
  def init
    @participant = Participant.find(params[:lender_id])
    @current_participation = Participation.find_by(user_id: current_user.id)
    @current_participant = Participant.find(@current_participation.participant_id)
    #@current_participant = Participant.find(16)
  end
end
