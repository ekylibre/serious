class ParticipationsController < ApplicationController
  def show
    session[:current_participation_id] = params[:id]
    redirect_to(controller: :games, action: :show, id: Participation.find(params[:id]).game)
  end
end
