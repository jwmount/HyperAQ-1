data = {objective: {name: @objective_name, note: @objective_note,
            owner_type: "Squad", owner_id: @objective_owner.id, parent_id: @parent_id}
          }
if @objective_id == 0
          HTTP.post("/api/v3/objective.json", payload: data) do |response|
            if response.ok?
              show_objective_modal! false
              UIHelpers::UIHelper.set_alert @objective_name, "has been created"
            else
              alert "Unable to create Objective"
            end
          end
        else
          HTTP.patch("/api/v3/objective/#{@objective_id}.json", payload: data) do |response|
            if response.ok?
              show_objective_modal! false
              UIHelpers::UIHelper.set_alert @objective_name, "has been updated"
            else
              alert "Unable to update Objective"
            end
          end
        end

