class MinuteHandsController < ApplicationController
  before_action :set_minute_hand, only: [:update]
  skip_before_action :verify_authenticity_token

  # PATCH/PUT /sprinkle_agents/1
  # PATCH/PUT /sprinkle_agents/1.json
  def update
    respond_to do |format|
      MinuteHandServer.run(key: WaterManager.first.key)
      format.json { render :show, status: :ok, location: @minute_hand }
    end
  end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_minute_hand
      @minute_hand = MinuteHand.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def minute_hand_params
      params.require(:minute_hand).permit(:state)
    end
end
