class ShopsController < BaseController
  before_action :find_records

  def show
  end

  def add
    item_catalog = @participant.catalog_items.find_by(variant: params[:variant])
    item = @deal.items.find_or_initialize_by(variant: params[:variant])
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
    item_catalog = @participant.catalog_items.find_by(variant: params[:variant])
    if (item = @deal.items.find_by(variant: item_catalog.variant))
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
    @deal.checkout
    redirect_to participant_url
  end

  def change_quantity
    if params[:quantity].to_d >= 1
      item = @deal.items.find_by(id: params[:item_id])
      item.update_attribute(:quantity, params[:quantity])
      item.save!
      @deal.save!
    else
      @deal.items.destroy(DealItem.find_by(id: params[:item_id]))
    end
    render partial: 'cart', locals: { deal: @deal } if request.xhr?
  end

  protected

  def find_records
    if (@participant = Participant.find(params[:id]))
      unless current_participant
        redirect_to params[:redirect] || { controller: :participants, action: :show, id: @participant.id }, alert: 'Cannot go to shop without participant'
      end
      @deal = Deal.find_or_create_by!(customer: current_participant, supplier: @participant, state: 'draft')
    else
      redirect_to params[:redirect] || { controller: :participants, action: :index }, alert: 'Participant not found'
    end
  end
end
