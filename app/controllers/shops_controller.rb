class ShopsController < ApplicationController
  before_action :authenticate_user!
  before_action :init
  before_action :find_deal

  layout 'shop'


  def show
    @catalog_item = CatalogItem.where( participant_id: params[:id] )
  end


  def add
    item = @deal.items.find_or_create_by(variant: params[:variant])
    item.quantity += 1
    item.save!
    redirect_to action: :show
  end

  def remove
    @deal.items.destroy(DealItem.find_by(variant: params[:variant]))
    redirect_to action: :show
  end

  def decrement

    item = @deal.items.find_or_create_by(variant: params[:variant])
    if item.quantity > 0
      item.quantity -= 1
      item.save!
    end
    redirect_to action: :show
  end

  def checkout

  end

  protected

  def find_deal
    @deal = Deal.find_or_create_by!(client: @current_participant, supplier: @participant)
    #Todo Créer la migration pour ajouter la colonne state et récupérer celle qui est en draft
  end

  def init
    @participant = Participant.find( params[:id] )
    participation =  Participation.find_by(user_id: current_user.id)
    @current_participant = Participant.find(participation.participant_id)
  end

end
