module Openseadragon 
  class Engine < ::Rails::Engine
    isolate_namespace Openseadragon

    if (Rails::VERSION::MAJOR > 3)
      config.assets.precompile += %w(openseadragon/*.png)
    end

  end
end

