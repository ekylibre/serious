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
end
