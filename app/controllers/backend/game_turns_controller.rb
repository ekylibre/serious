class Backend::GameTurnsController < Backend::BaseController

  def edit
    @game_turn = GameTurn.find(params[:id])
  end

  def update
    @game_turn = GameTurn.find(params[:id])
    @game_turn.update!(game_turn_params)
    Game.find(@game_turn.game).update_turn(@game_turn)
    redirect_to backend_game_path(@game_turn.game_id)
  end

  private
  def game_turn_params
    params.require(:game_turn).permit(:started_at, :stopped_at)
  end
end
