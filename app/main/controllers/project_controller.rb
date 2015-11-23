module Main
  class MainController < Volt::ModelController
    before_action :require_login
    
    def show

    end


  end
end