# By default Volt generates this controller for your Main component
module Main
  class MainController < Volt::ModelController
    def index
      # Add code for when the index view is loaded
      page._new_project_name = ''
    end

    def add_new_project
      unless page._new_project_name == ''
        Volt.current_user.id.then do |result|
          store._projects << {
            user_id: result,
            name: page._new_project_name
          }
          page._new_project_name = ''
        end
      end
    end

    def destroy_project(project)
      project.destroy if `confirm("Are you sure you want to delete that?")`
    end

    def about
      # Add code for when the about view is loaded
    end

    private

    # The main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._component, params._controller, and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end

    # Determine if the current nav component is the active one by looking
    # at the first part of the url against the href attribute.
    def active_tab?
      url.path.split('/')[1] == attrs.href.split('/')[1]
    end
  end
end
