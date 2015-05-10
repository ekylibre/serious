class GamesController < BaseController
  before_action :authenticate_user!

  layout "public"


  def index
    @games = current_user.games
  end

  def show
    @game = Game.find_by(id: params[:id])
  end

end
