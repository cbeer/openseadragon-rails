module Openseadragon
  class Info
    attr_accessor :id

    def initialize(attributes = {})
      self.id = attributes[:id]
    end
    
    def to_tilesource
      id
    end
  end
end
