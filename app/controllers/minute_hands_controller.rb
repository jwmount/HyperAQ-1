class MinuteHandsController < ApplicationController
  before_action :set_minute_hand, only: [:update]
  skip_before_action :verify_authenticity_token

  SERVER_OP_HANDLER = false

  # PATCH/PUT /minute_hand/1
  # PATCH/PUT /minute_hand/1.json
  def update
    respond_to do |format|
      if SERVER_OP_HANDLER
        log "Using server op to manage minute_hand ticks\n"
        MinuteHandServer.run(param: minute_hand_params[:key])
        format.json { render :show, status: :ok, location: @minute_hand }
      else
        log "Using manipulate_and_update to manage minute_hand ticks\n"
        @minute_hand.manipulate_and_update(minute_hand_params)
      end
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
      params.require(:minute_hand).permit(:key)
    end

    LOGFILE = "log/minute_hand.log"
    LOG_TIME = "%H:%M:%S"

    def log_time
      Time.now.strftime(LOG_TIME)
    end

    def log(msg)
      f = File.open(LOGFILE, 'a')
      # f.write msg
      f.write "#{log_time} #{msg}"
      f.close
    end

end
