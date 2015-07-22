require_relative '../phase5/controller_base'

module Phase6
  class ControllerBase < Phase5::ControllerBase
    # use this with the router to call action_name (:index, :show, :create...)
    def invoke_action(action_name)
      send(action_name)
      unless already_built_response
        render(action_name)
      end
    end
  end
end
