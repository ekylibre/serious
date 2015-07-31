class GamesController < BaseController

  def index
    @games = current_user.games
  end

  def show
    unless @game = Game.find_by(id: params[:id])
      redirect_to :index
    end
  end


  def show_current_turn
    if (game_id = params[:id])
      game = Game.find(game_id)
      turn = game.current_turn
    elsif current_game
      game = current_game
      turn = game.turns.find_by(number: current_turn)
    else
      raise "Cannot return turn without current game"
    end
    if game.current_turn.nil?
      render json: {state: 'finished'}
    else
      render json: {number: current_turn, stopped_at: turn.stopped_at.utc.l(format: '%Y-%m-%dT%H:%M:%S'), name: turn.name, number_turn: game.current_turn.number, turn_count: game.turns_count, state: 'running'}
    end

  end

  # Run a game
  def run
    unless @game = Game.find_by(id: params[:id])
      redirect_to :index
      return
    end
    @game.run! true
    redirect_to game_path(@game)
  end

end
