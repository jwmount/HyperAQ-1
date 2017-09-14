
  class WaterStatus < Hyperloop::Component

    ACTIVE =  'Active'
    STANDBY = 'Standby'

    def render
      UL(class: 'nav navbar-nav')  do
        LI do
          BUTTON(class: "btn #{system_button_state} navbar-btn") do 
            system_state
          end.on(:click) {state_button_toggled}
        end
      end
    end

    def system_state
      WaterManager.first.state
    end

    def state_button_toggled
      # Note: The state is changed in the following ServerOp, which directly updates the model, and
      # then hyperloop will push the change back to the client, where the reactive-memory mapping of 
      # Active Record models will cause the button color to toggle accordingly.
      WaterManagerServer.run(wm_id: WaterManager.first.id)
    end

    def system_button_state
      system_state == ACTIVE ? 'btn-warning' : 'btn-info'
    end

  end

