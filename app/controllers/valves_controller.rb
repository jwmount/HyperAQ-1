require 'json'
class ValvesController < ApplicationController
  before_action :set_valve, only: [:update]
  skip_before_action :verify_authenticity_token

  LOGFILE = "log/valve_controller.log"

  def log(msg)
    f = File.open(LOGFILE, 'a')
    f.write msg
    f.close
  end

  # PATCH/PUT /valves/1.json
  def update
    # log "crontab PATCH received, valve --> #{@valve.name}, valve_params --> #{valve_params.to_json}\n"
    respond_to do |format|
      if @valve.manipulate_and_update(valve_params, @valve)
        format.html { redirect_to @valve, notice: 'Valve was successfully updated.' }
        format.json { render :show, status: :ok, location: @valve }
      else
        format.html { render :edit }
        format.json { render json: @valve.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_valve
      @valve = Valve.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def valve_params
      params.require(:valve).permit(:name, :gpio_pin, :active_sprinkle_id, :active_history_id, :cmd)
    end
end
