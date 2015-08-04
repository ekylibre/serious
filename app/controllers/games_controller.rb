class GamesController < BaseController
  def index
    @games = current_user.games
  end

  def show
    redirect_to :index unless @game = Game.find_by(id: params[:id])
  end

  # Show current turn infos of a given game or current_game if none given
  def show_current_turn
    unless game = (params[:id] ? Game.find(params[:id]) : current_game)
      fail 'Cannot return turn without current game'
    end
    data = { state: game.state, turns_count: game.turns_count }
    if turn = game.current_turn
      data.merge!(number: turn.number, stopped_at: turn.stopped_at.l(format: '%Y-%m-%dT%H:%M:%S'), name: turn.name)
    end
    render json: data
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
