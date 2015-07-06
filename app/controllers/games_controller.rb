class GamesController < BaseController
  before_action :authenticate_user!

  def index
    @games = current_user.games
  end

  def show
    @game = Game.find_by(id: params[:id])
    @actors = Actor.where(:game_id => @game.id)
    @farms = Farm.where(game_id: @game.id)
    @current_turn = 28
    @news = ScenarioBroadcast.where({:scenario_id => 1, :release_turn => @current_turn + 1})
    #@news = ScenarioBroadcast.where(:scenario_id => @game.scenario_id)
    #@curves = ScenarioCurve.where(:scenario_id => @game.scenario_id)

    @participation = Participation.find_by(game_id: @game.id, user_id: current_user.id)
    @participant = Participant.find(@participation.participant_id)

    @curves = ScenarioCurve.where(:scenario_id => 1)
    render layout: 'game'

  end

end
