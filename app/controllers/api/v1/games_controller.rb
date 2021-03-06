class Api::V1::GamesController < Api::V1::BaseController
  before_action :authorize!

  def show
    render json: @game.configuration(url: game_url(@game))
  end

  def prepare
    @game.update_column(:state, :in_preparation)
    render json: { status: 'ok' }
  end

  def confirm
    @game.update_column(:state, :ready)
    render json: { status: 'ok' }
  end

  def historic
    if @game.historic.file?
      send_file @game.historic.path
    else
      render json: 'nil'
    end
  end

  # Register notes of farms
  def evaluate
    puts params[:rating].inspect.yellow
    params[:ratings].each do |tenant, report|
      participant = @game.participants.find_by(tenant: tenant)
      if participant
        participant.ratings.create!(report: report, rated_at: Time.parse(report[:stopped_at]))
      else
        puts "Cannot find participant #{tenant}"
      end
    end
    render json: { status: 'ok' }
  end

  protected

  def authorize!
    @game = Game.find(params[:id])
    authorization = request.headers['Authorization'].to_s.strip.split(/\s+/)
    unless authorization.first == 'g-token' && authorization.second == @game.access_token
      head :forbidden
      return false
    end
  end
end
