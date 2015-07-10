class GamesController < BaseController
  before_action :authenticate_user!

  def index
    @games = current_user.games
    @current_user = current_user
  end

  def show
    @game = Game.find_by(id: params[:id])
    @actors = @game.actors
    @farms = @game.farms
    @current_turn = 6
    scenario = @game.scenario || Scenario.first
    @broadcasts = scenario.broadcasts.where(release_turn: @current_turn + 1)
    # @curves = scenario.curves

    @current_participation = @game.participations.includes(:participant).find_by(user_id: current_user.id)
    @current_participant = @current_participation.participant

    @curves = scenario.curves
    render layout: 'game'
  end

end
