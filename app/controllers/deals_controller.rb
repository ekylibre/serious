class DealsController < BaseController
  before_action :check_running_game

  def show
    @deal = Deal.find(params[:id])
  end

  def new
    @deal = Deal.new(customer: @customer, supplier: @supplier)
  end

  def destroy
    deal = Deal.find(params[:id])
    Deal.destroy(deal)
    redirect_to params[:redirect] || participant_url(current_participant.nil? ? deal.supplier : deal.supplier == current_participant ? deal.customer : deal.supplier)
  end

  def add_to_cart
    supplier = Participant.find(params[:supplier_id])
    customer = Participant.find(params[:customer_id])
    catalog_item = CatalogItem.find(params[:catalog_item_id])
    fail "No way" unless supplier == current_participant or current_participant == customer
    fail "No way again" unless catalog_item.participant == supplier
    unless deal = customer.purchases.where(supplier_id: supplier.id, state: :draft).order(id: :desc).first
      deal = customer.purchases.create!(supplier: supplier, game: supplier.game)
    end
    item = deal.items.find_or_initialize_by(catalog_item_id: catalog_item.id)
    item.quantity += params[:quantity] || 1
    item.save!
    redirect_to params[:redirect] || {controller: :participants, action: :show, id: supplier.id}
  end

  def checkout
    deal = Deal.find(params[:id])
    deal.checkout
    redirect_to params[:redirect] || {controller: :participants, action: :show, id: deal.supplier.id}
  end

  def change_quantity
    deal = Deal.find(params[:id])
    item = deal.items.find(params[:item_id])
    if params[:quantity].to_d >= 1
      item.update_attribute(:quantity, params[:quantity])
      item.save!
    else
      DealItem.destroy(item)
    end
    if request.xhr?
      render partial: 'cart', locals: { deal: deal, supplier: deal.supplier }
    else
      redirect_to params[:redirect] || {controller: :participants, action: :show, id: deal.supplier.id}
    end
  end

end
