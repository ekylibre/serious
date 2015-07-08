class LoansController < ApplicationController
  before_action 'init'
  layout 'loan'

  def new
    @loan = Loan.new
    @loan.borrower = @current_participant
    @loan.lender = @participant
    puts @loan.inspect
    #redirect_to action: :show, id: params[:id]
  end

  def create

  end

  protected
  def init
    @participant = Participant.find(params[:lender_id])
    @current_participant = Participant.find(current_user.id)
  end
end
