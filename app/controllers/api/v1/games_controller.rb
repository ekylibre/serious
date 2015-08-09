class Api::V1::GamesController < Api::V1::BaseController
  before_action :authorize!

  def show
    render json: @game.configuration(url: game_url(@game))
  end

  def confirm
    @game.update_column(:state, :ready) if @game.planned?
    render json: 'ok'
  end

  def historic
    if @game.historic.file?
      send_file @game.historic.path
    else
      render json: 'nil'
    end
  end

  protected

  def authorize!
    @game = Game.find(params[:id])
    authorization = request.headers['Authorization'].to_s.strip.split(/\s+/)
    unless authorization.first == 'g-token' && authorization.second == @game.access_token
      head :forbidden
      return falsecontent_type
    end
  end
end
