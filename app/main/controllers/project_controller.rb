module Main
  class ProjectController < Volt::ModelController
    before_action :require_login
    
    def show
      page._new_task_name = ''
    end

    def add_new_task
      unless page._new_task_name == ''
        store._tasks << {
          project_id: params.id,
          name: page._new_task_name
        }
        page._new_task_name = ''
      end
    end

    def destroy_task(task)
      task.destroy if `confirm("Are you sure you want to delete that?")`
    end

  end
end