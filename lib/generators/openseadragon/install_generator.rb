require 'rails/generators'

module Openseadragon
  class Install < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    
    def assets
      copy_file "openseadragon.css", "app/assets/stylesheets/openseadragon.css"
      copy_file "openseadragon.js", "app/assets/javascripts/openseadragon.js"
    end

    def inject_helper
      inject_into_class 'app/controllers/application_controller.rb', ApplicationController do
        "  helper Openseadragon::OpenseadragonHelper\n"
      end
    end
  end
end