class DealItemsController < BaseController
  before_action :check_running_game

  def destroy
    deal_item = DealItem.find(params[:id])
    deal = deal_item.deal
    DealItem.destroy(deal_item)
    redirect_to params[:redirect] || participant_url(current_participant.nil? ? deal.supplier : deal.supplier == current_participant ? deal.customer : deal.supplier)
  end

end
