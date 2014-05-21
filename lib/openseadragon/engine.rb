module Openseadragon 
  class Engine < ::Rails::Engine
    isolate_namespace Openseadragon

    config.assets.precompile += %w(openseadragon/*.png)

  end
end

