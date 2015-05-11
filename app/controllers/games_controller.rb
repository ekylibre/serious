class GamesController < BaseController
  before_action :authenticate_user!

  def index
    @games = current_user.games
  end

  def show
    @game = Game.find_by(id: params[:id])
    render layout: "game"
  end

end
