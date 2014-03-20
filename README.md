# OpenSeadragon [![Gem Version](https://badge.fury.io/rb/openseadragon.png)](http://badge.fury.io/rb/openseadragon)

OpenSeadragon is a javascript library for displaying tiling images. This gem packages those assets and some Rails helpers for using them.

http://openseadragon.github.io/

# Setup

In order to display a file, OpenSeadragon needs to know the full dimension of the image.  In order to do this we need to inject an image resolver. Here's an example.

```ruby
    module ImageResolver
      def self.find(id)
        # Custom code here to find the height & width
        Openseadragon::Image.new(id: id, height: 4000, width: 8000)
      end
    end

    # register the resolver
    Openseadragon::Image.file_resolver = ImageResolver
```

The image resolver only needs to implement the `find` method. It takes an id as a parameter and returns a new instance of `Openseadragon::Image`

