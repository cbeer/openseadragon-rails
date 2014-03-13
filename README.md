# OpenSeadragon

OpenSeadragon is a javascript library for displaying tiling images. This gem packages those assets and some Rails helpers for using them.

http://openseadragon.github.io/

# Setup

In order to display a file, OpenSeadragon needs to know the full dimension of the image.  In order to do this we need to inject an image resolver. Here's an example.

```ruby
    module SpecResolver
      def self.find(id)
        # Custom code here to find the height & width
        Openseadragon::Image.new(id: id, height: 4000, width: 8000)
      end
    end

    # register the resolver
    Openseadragon::Image.file_resolver = SpecResolver
```

