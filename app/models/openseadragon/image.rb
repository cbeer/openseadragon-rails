module Openseadragon
  class Image
    attr_accessor :id, :width, :height

    class_attribute :file_resolver
   
    class << self
      def find(id)
        file_resolver.find(id)
      end
    end

    def initialize(attributes = {})
      self.id = attributes[:id]
      self.width = attributes[:width]
      self.height = attributes[:height]
    end

    def as_json
      { id: id}
    end
  end
end
