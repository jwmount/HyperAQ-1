class PortersController < ApplicationController
  before_action :set_porter, only: [:show]
  skip_before_action :verify_authenticity_token

  # GET /porters/1
  # GET /porters/1.json
  def show
    Porter.first.update(host_name: `hostname`.strip, port_number: request.port)
    # Porter.log("Porter.show got called!, #{Porter.first.host_with_port}\n")
    Porter.first.host_with_port.to_json
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_porter
      @porter = Porter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def porter_params
      params.require(:porter).permit(:host_name, :port_number)
    end
end
