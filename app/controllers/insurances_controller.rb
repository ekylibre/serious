class InsurancesController < BaseController
  def new
    @is_disabled = false
    @participant = Participant.find(params[:insurer_id])
    @insurance = Insurance.new
    @insurance.insurer = @participant
    @insurance.insured = Participant.find(params[:insured_id])
    if current_participant.insured && @participant.insurer
      @insurance.nature = 'harvest'
      @insurance.quantity_unit = 'hectare'
      @insurance.quantity_value = 200
      @insurance.amount = 2000
      @insurance.unit_pretax_amount = 20
      @insurance.tax_percentage = 20
      @insurance.excess_amount = 200
      @is_disabled = true
    end
  end

  def create
    @insurance = Insurance.new(insurance_params)
    @insurer = Participant.find(@insurance.insurer_id)
    @insurance.game_id = @insurer.game_id
    respond_to do |format|
      if @insurance.save
        format.html { redirect_to @insurer, notice: 'Insurance was successfully created.' }
        format.json { render :show, status: :created, location: @insurance }
      else
        format.html { render :new, notice: 'Registration problem' }
        format.json { render json: @insurance.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  private

  def insurance_params
    params.require(:insurance).permit(:insurer_id, :insured_id, :nature, :quantity_unit, :unit_refundable_amount,
                                      :unit_pretax_amount, :tax_percentage, :quantity_value, :excess_amount)
  end
end
