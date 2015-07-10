class ParticipationsController < BaseController

  def show
    participation = Participation.find(params[:id])
    session[:current_participation_id] = participation.id
    if participation.organizer?
      redirect_to(controller: :games, action: :show, id: participation.game_id)
    else
      redirect_to(controller: :participants, action: :show, id: participation.participant_id)
    end
  end

end
