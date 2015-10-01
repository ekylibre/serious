# coding: utf-8
class GamesController < BaseController
  before_action :check_game, except: :index
  def index
    @games = current_user.games
  end

  def show
    unless current_participation
      redirect_to(action: :index)
      return
    end
    @game = Game.find_by(id: params[:id])
    # FIXME: Very crade code
    @game.update_column(:state, :finished) if @game.last_turn.stopped_at < Time.zone.now
    session[:view_mode] = params['mode'].to_s if params['mode']
    session[:view_mode] ||= 'map'
    session[:view_mode] = 'simple' unless @game.running?
    if @game
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
    (data = { state: game.state, turns_count: game.turns_count })
    if (turn = game.current_turn)
      data.merge!(number: turn.number, stopped_at: turn.stopped_at.utc.l(format: '%Y-%m-%dT%H:%M:%SZ'), name: turn.name)
    end
    render json: data
  end

  # trigger issue
  def trigger_issue
    unless (scenario_issue = ScenarioIssue.find(params[:id]))
      fail 'Cannot find issue n°' + params[:id]
    end
    scenario_issue.trigger_turn = current_turn
    scenario_issue.save!
    current_game.trigger_issue(scenario_issue)
    redirect_to game_path(current_game)
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

  def current_turn_broadcasts_and_curves
    if @game = Game.find_by(id: params[:id]) and @game.current_turn and (broadcasts = @game.broadcasts.where(release_turn: @game.current_turn.number)) and broadcasts.any? and
       (curves = @game.reference_curves) and curves.any?
      render json: {
        # broadcasts: broadcasts.collect{|b| {
        #  name: truncate(b.name, length: 90),
        #  content: truncate(b.content, length: 200)
        # }},
        broadcasts: broadcasts,
        curves: curves
      }.to_json
    else
      render json: 'nil'
    end
  end

  def turns
    if game = Game.find_by(id: params[:id]) and turns = game.turns
      render json: turns.to_json
    else
      render json: 'nil'
    end
  end
end
