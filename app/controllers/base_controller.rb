class BaseController < ApplicationController
  attr_reader :current_participation, :current_participant, :current_game, :current_turn
  helper_method :current_participation, :current_participant, :current_game, :current_turn

  before_action :authenticate_user!
  before_action :set_participation

  layout 'game'

  protected

  # Set env
  def set_participation
    if (@current_participation = Participation.includes(:participant, :game).find_by(id: session[:current_participation_id], user_id: current_user.id))
      @current_participant = @current_participation.participant
      @current_game = @current_participation.game
      @current_turn = @current_game.current_turn.number if @current_game.current_turn
    end
  end

  # Check that game is accessible by user
  def check_game
    return true if current_user.administrator?
    if current_participation
      return check_running_game unless current_participation.organizer?
    end
    false
  end

  # Check that game is running
  def check_running_game
    return true if current_game && current_game.running? && current_game.current_turn
    redirect_to games_url
    false
  end
end
