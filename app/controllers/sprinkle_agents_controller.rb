class SprinkleAgentsController < ApplicationController
  before_action :set_sprinkle_agent, only: [:show, :edit, :update, :destroy]

  # GET /sprinkle_agents
  # GET /sprinkle_agents.json
  def index
    @sprinkle_agents = SprinkleAgent.all
  end

  # GET /sprinkle_agents/1
  # GET /sprinkle_agents/1.json
  def show
  end

  # GET /sprinkle_agents/new
  def new
    @sprinkle_agent = SprinkleAgent.new
  end

  # GET /sprinkle_agents/1/edit
  def edit
  end

  # POST /sprinkle_agents
  # POST /sprinkle_agents.json
  def create
    @sprinkle_agent = SprinkleAgent.new(sprinkle_agent_params)

    respond_to do |format|
      if @sprinkle_agent.save
        format.html { redirect_to @sprinkle_agent, notice: 'Sprinkle agent was successfully created.' }
        format.json { render :show, status: :created, location: @sprinkle_agent }
      else
        format.html { render :new }
        format.json { render json: @sprinkle_agent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sprinkle_agents/1
  # PATCH/PUT /sprinkle_agents/1.json
  def update
    respond_to do |format|
      if @sprinkle_agent.update(sprinkle_agent_params)
        format.html { redirect_to @sprinkle_agent, notice: 'Sprinkle agent was successfully updated.' }
        format.json { render :show, status: :ok, location: @sprinkle_agent }
      else
        format.html { render :edit }
        format.json { render json: @sprinkle_agent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sprinkle_agents/1
  # DELETE /sprinkle_agents/1.json
  def destroy
    @sprinkle_agent.destroy
    respond_to do |format|
      format.html { redirect_to sprinkle_agents_url, notice: 'Sprinkle agent was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sprinkle_agent
      @sprinkle_agent = SprinkleAgent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sprinkle_agent_params
      params.require(:sprinkle_agent).permit(:sprinkle_id)
    end
end
