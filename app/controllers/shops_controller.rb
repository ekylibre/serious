class ShopsController < BaseController
  before_action :authenticate_user!
  before_action :init
  before_action :find_deal

  layout 'shop'

  def show
  end

  def add
    item_catalog = @catalog_item.find_by(variant: params[:variant])
    item = @deal.items.find_or_initialize_by( variant: params[:variant] )
    item.quantity += 1

    item.unit_pretax_amount = item_catalog.pretax_amount
    item.unit_amount = item_catalog.amount
    item.save!
    redirect_to action: :show
  end

  def remove
    item = DealItem.find_by(variant: params[:variant])
    @deal.items.destroy(DealItem.find_by(variant: item.variant))
    redirect_to action: :show
  end

  def decrement
    item_catalog = @catalog_item.find_by(variant: params[:variant])
    if item = @deal.items.find_by(variant: item_catalog.variant)
      if item.quantity - 1 > 0
        item.quantity -= 1
        item.save!
      else
        @deal.items.destroy(DealItem.find_by(variant: item.variant))
      end
    end
    redirect_to action: :show
  end

  def checkout
    @deal.state = 'invoice'
    @deal.save!
    redirect_to participant_url
  end


  protected

  def find_deal
    @deal = Deal.find_or_create_by!(customer: @current_participant, supplier: @participant, state: 'draft')
  end

  def init
    @catalog_item = CatalogItem.where( participant_id: params[:id] )
    @participant = Participant.find( params[:id] )
    participation =  Participation.find_by(user_id: current_user.id)
    unless @current_participant = participation.participant
      redirect_to controller: :games, action: :show, id: participation.game_id, alert: "Need a participation"
      return false
    end
  end

end
