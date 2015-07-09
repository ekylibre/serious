# coding: utf-8
class ParticipantsController < BaseController
  before_action :authenticate_user!
  layout 'game'

  def show
    @participation = Participation.find_by( participant_id: params[:id] )
    @participant = Participant.find(params[:id])
    @game = Game.find_by(id: @participant.game_id)
    @user = User.find(current_user.id)
    @current_participation = Participation.find_by(user_id: @user.id)
    @current_participant = @current_participation.participant

    # Todo Récupérer la courbe des finances d'une ferme
    #@curve = ScenarioCurve.find(1)

    if @participant.is_a?(Actor)
      @purchases = Deal.joins(:supplier).where(customer: current_participant, supplier: @participant, state: 'invoice')
      @sales = Deal.joins(:customer).where(supplier: current_participant, customer: @participant, state: 'invoice')
    else
      @purchases = Deal.joins(:supplier).where(customer: current_participant, state: 'invoice')
      @sales = Deal.joins(:customer).where(supplier: current_participant, state: 'invoice')
    end
  end

  def index
  end

  protected

  def find_name_customer(purchase)
    Participant.find(purchase.supplier_id).name
  end

end
