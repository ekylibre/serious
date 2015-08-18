class DealsController < BaseController
  before_action :check_running_game

  def show
    @deal = Deal.find(params[:id])
  end

  def new
    @deal = Deal.new(customer: @customer, supplier: @supplier)
  end

  def checkout
    deal = Deal.find(params[:id])
    deal.checkout
    redirect_to params[:redirect] || participant_url(current_participant.nil? ? deal.supplier : deal.supplier == current_participant ? deal.customer : deal.supplier)
  end

  def cancel
    fail NotImplementedError
  end

  def destroy
    deal = Deal.find(params[:id])
    Deal.destroy(deal)
    redirect_to params[:redirect] || participant_url(current_participant.nil? ? deal.supplier : deal.supplier == current_participant ? deal.customer : deal.supplier)
  end

  def add_to_cart
    supplier = Participant.find(params[:supplier_id])
    customer = Participant.find(params[:customer_id])
    # fail 'No way' unless supplier == current_participant || current_participant == customer
    # fail 'No way again' unless catalog_item.participant == supplier

    unless (deal = customer.purchases.where(supplier_id: supplier.id, state: :draft).order(id: :desc).first)
      deal = customer.purchases.create!(supplier: supplier, game: supplier.game)
    end

    if !(catalog_item_id = params[:catalog_item_id]).nil?
      item = deal.items.find_or_initialize_by(catalog_item_id: catalog_item_id)
    elsif !(product_id = params[:product_id]).nil?
      item = deal.items.find_or_initialize_by(product_id: product_id, variant: params[:variant], tax: params[:tax],
                                              unit_pretax_amount: params[:unit_pretax_amount])
    elsif !(variant = params[:variant]).nil?
      item = deal.items.find_or_initialize_by(variant: variant)
    else
      item = nil
      fail "Erreur l'item n'existe pas"
    end

    unless item.nil?
      item.quantity += params[:quantity] || 1
      item.save!
      redirect_to params[:redirect] || participant_url(current_participant.nil? ? deal.supplier : deal.supplier ==
                                                           current_participant ? deal.customer : deal.supplier)
    end
  end

  def change_quantity
    deal = Deal.find(params[:id])
    item = deal.items.find(params[:item_id])
    if params[:quantity].to_d >= 1
      item.quantity = params[:quantity]
      item.save!
    else
      DealItem.destroy(item)
    end
    deal.reload
    if request.xhr?
      render partial: 'cart', locals: { deal: deal, supplier: deal.supplier }
    else
      redirect_to params[:redirect] || participant_url(current_participant.nil? ? deal.supplier : deal.supplier ==
                                                           current_participant ? deal.customer : deal.supplier)
    end
  end
end
