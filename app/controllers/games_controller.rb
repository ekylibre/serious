class GamesController < BaseController

  def index
    @games = current_user.games
  end

  def show
    unless (@game = Game.find_by(id: params[:id]))
      redirect_to :index
    end
  end

  def show_current_turn
    if (id_game = params[:id])
      game = Game.find(id_game)
      turn = game.current_turn
    elsif current_game
      game = current_game
      turn = game.turns.find_by(number: current_turn)
    else
      raise('erreur')
    end
    if game.current_turn.nil?
      render json: {state: 'finished'}
    else
      render json: {number: current_turn, stopped_at: turn.stopped_at.utc.l(format: '%Y-%m-%dT%H:%M:%S'), name: turn.name, number_turn: game.current_turn.number, turn_count: game.turns_count, state: 'running'}
    end

  end
end
