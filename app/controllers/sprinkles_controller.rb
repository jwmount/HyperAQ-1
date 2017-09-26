
require 'json'

class SprinklesController < ApplicationController
  before_action :set_sprinkle, only: [:update]
  skip_before_action :verify_authenticity_token

  # PATCH/PUT /sprinkles/1.json
  def update
    respond_to do |format|
      # replace this method with the original, and implement an update method in the Sprinkle class
      if @sprinkle.manipulate_and_update(sprinkle_params)
        format.json { render :show, status: :ok, location: @sprinkle }
      else
        format.json { render json: @sprinkle.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sprinkle
      @sprinkle = Sprinkle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sprinkle_params
      params.require(:sprinkle).permit(:state, :key, :sprinkle_agent_id)
    end

end
