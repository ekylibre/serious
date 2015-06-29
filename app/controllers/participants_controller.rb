class ParticipantsController < BaseController
  before_action :authenticate_user!
  layout 'participant'

  def show
    @participation = Participation.find_by( participant_id: params[:id] )
    @participant = Participant.find( params[:id] )
    @game = Game.find_by( id: @participant.game_id )
    @user = User.find(current_user.id)

    # Todo Récupérer la courbe des finances d'une ferme
    @curve = ScenarioCurve.find(1)
  end

  def index

  end
end
