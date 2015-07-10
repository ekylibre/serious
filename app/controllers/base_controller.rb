class BaseController < ApplicationController
  attr_reader :current_participation, :current_participant
  helper_method :current_participation, :current_participant

  before_action :authenticate_user!
  before_action :set_participation

  layout "game"

  protected

  # Set env
  def set_participation
    if @current_participation = Participation.includes(:participant).find_by(id: session[:current_participation_id])
      @current_participant = @current_participation.participant
    end
  end

end
