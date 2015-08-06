class Api::V1::GamesController < Api::V1::BaseController
  def show
    @game = Game.find(params[:id])
    token = request.headers['X-Serious-Auth-Token'] || request.headers['X-Auth-Token']
    unless @game.access_token == token
      head :forbidden
      return
    end
    render json: @game.configuration(url: game_url(@game))
  end
end
