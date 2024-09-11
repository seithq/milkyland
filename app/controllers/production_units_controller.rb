class ProductionUnitsController < ApplicationController
  before_action :set_production_unit, only: %i[ show edit update destroy ]

  # GET /production_units or /production_units.json
  def index
    @production_units = ProductionUnit.all
  end

  # GET /production_units/1 or /production_units/1.json
  def show
  end

  # GET /production_units/new
  def new
    @production_unit = ProductionUnit.new
  end

  # GET /production_units/1/edit
  def edit
  end

  # POST /production_units or /production_units.json
  def create
    @production_unit = ProductionUnit.new(production_unit_params)

    respond_to do |format|
      if @production_unit.save
        format.html { redirect_to production_unit_url(@production_unit), notice: "Production unit was successfully created." }
        format.json { render :show, status: :created, location: @production_unit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @production_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /production_units/1 or /production_units/1.json
  def update
    respond_to do |format|
      if @production_unit.update(production_unit_params)
        format.html { redirect_to production_unit_url(@production_unit), notice: "Production unit was successfully updated." }
        format.json { render :show, status: :ok, location: @production_unit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @production_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /production_units/1 or /production_units/1.json
  def destroy
    @production_unit.destroy!

    respond_to do |format|
      format.html { redirect_to production_units_url, notice: "Production unit was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_production_unit
      @production_unit = ProductionUnit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def production_unit_params
      params.require(:production_unit).permit(:plan_id, :group_id, :count, :tonnage, :status, :comment)
    end
end
