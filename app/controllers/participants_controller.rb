class ParticipantsController < BaseController
  before_action :check_game

  def index
    if current_participation
      redirect_to controller: :games, action: :show, id: current_participation.game_id
    else
      redirect_to controller: :games, action: :index
    end
  end

  def show
    unless (@participant = Participant.find_by(id: params[:id]))
      redirect_to :index, alert: 'Participant not found'
    end
  end

  def affairs_with
    participant = Participant.find_by(id: params[:id])
    other = Participant.find_by(id: params[:other_id])
    if participant
      render json: participant.affairs_with(other).to_json
    else
      render json: 'nil'
    end
  end
end
