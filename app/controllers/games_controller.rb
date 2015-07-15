class GamesController < BaseController

  def index
    @games = current_user.games
  end

  def show
    unless (@game = Game.find_by(id: params[:id]))
      redirect_to :index
    end
  end

end
