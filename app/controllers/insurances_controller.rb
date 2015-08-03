class InsurancesController < BaseController

  def new
    @participant = Participant.find(params[:insurer_id])
    @insurance = Insurance.new
    @insurance.insurer = @participant
  end

  def create
    @insurance = Insurance.new(insurance_params)
    puts '---------'
    puts @insurance.insured
    puts '---------'
    @participant = Participant.find(@insurance.insurer)
    respond_to do |format|
      if @insurance.save
        format.html { redirect_to @participant, notice: 'Insurance was successfully created.' }
        format.json { render :show, status: :created, location: @insurance }
      else
        format.html { render :new }
        format.json { render json: @insurance.errors, status: :unprocessable_entity }
      end
    end
  end


  def show
  end

  private
  def insurance_params
    params.require(:insurance).permit(:insurer, :insured, :nature, :quantity_unit, :amount, :unit_pretax_amount, :tax, :quantity_value, :excess_amount)
  end
end
