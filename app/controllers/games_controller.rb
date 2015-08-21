class GamesController < BaseController
  before_action :check_game, except: :index

  def index
    @games = current_user.games
  end

  def show
    if (@game = Game.find_by(id: params[:id]))
      @scenario_issues = ScenarioIssue.where(scenario_id: @game.scenario_id)
    else
      redirect_to :index
    end
  end

  # Show current turn infos of a given game or current_game if none given
  def show_current_turn
    unless (game = (params[:id] ? Game.find(params[:id]) : current_game))
      fail 'Cannot return turn without current game'
    end
    (data = {state: game.state, turns_count: game.turns_count})
    if (turn = game.current_turn)
      data.merge!(number: turn.number, stopped_at: turn.stopped_at.utc.l(format: '%Y-%m-%dT%H:%M:%SZ'), name: turn.name) #Add z on utc for firefox
    end
    render json: data
  end

  # trigger issue
  def trigger_issue

  end

  # Run a game
  def run
    unless (@game = Game.find_by(id: params[:id]))
      redirect_to :index
      return
    end
    @game.run!
    redirect_to game_path(@game)
  end
end
