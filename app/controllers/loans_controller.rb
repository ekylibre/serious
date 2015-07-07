class LoansController < ApplicationController
  before_action :authenticate_user!
  def show


  end

  protected
  def initialize
    @participant = Participant.find(params[:id])
  end
end
