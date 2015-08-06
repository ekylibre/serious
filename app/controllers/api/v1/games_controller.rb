class Api::V1::GamesController < Api::V1::BaseController
  def show
    @game = Game.find(params[:id])
    authorization = request.headers['Authorization'].to_s.strip.split(/\s+/)
    unless authorization.first == "g-token" && authorization.second == @game.access_token
      head :forbidden
      return
    end
    render json: @game.configuration(url: game_url(@game))
  end
end
