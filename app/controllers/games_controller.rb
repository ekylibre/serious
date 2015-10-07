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
    return unless find_resource
    session[:view_mode] = params['mode'].to_s if params['mode']
    session[:view_mode] ||= 'map'
    if !@game.running? || (session[:view_mode] == 'ratings' && !(current_participation.organizer? || current_user.administrator?))
      session[:view_mode] = 'simple'
    end
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

  # Trigger an issue to all farms
  def trigger_issue
    scenario_issue = ScenarioIssue.find(params[:id])
    scenario_issue.trigger_turn = current_turn
    scenario_issue.save!
    current_game.trigger(scenario_issue)
    redirect_to game_path(current_game)
  end

  def pay_expenses
    current_game.pay_expenses!
    redirect_to game_path(current_game)
  end

  # Evaluate farms for a game
  def evaluate
    return unless find_resource
    @game.evaluate!
    redirect_to game_path(@game)
  end

  # Prepare farms for a game
  def prepare
    return unless find_resource
    @game.prepare!
    redirect_to game_path(@game)
  end

  # Start a game
  def start
    return unless find_resource
    @game.start!
    redirect_to game_path(@game)
  end

  # Cancel a game
  def cancel
    return unless find_resource
    @game.cancel!
    redirect_to game_path(@game)
  end

  # Stop a game
  def stop
    return unless find_resource
    @game.stop!
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

  protected

  def find_resource
    @game = Game.find_by(id: params[:id])
    unless @game
      redirect_to :index
      return false
    end
    true
  end
end
