# OpenSeadragon [![Gem Version](https://badge.fury.io/rb/openseadragon.png)](http://badge.fury.io/rb/openseadragon)

OpenSeadragon is a javascript library for displaying tiling images. This gem packages those assets and some Rails helpers for using them.

http://openseadragon.github.io/
### Using IIIF metadata
```ruby
# Single image
image_data = Openseadragon::Info.new(id: 'uri:to/info.json')
openseadragon_viewer(image_data)

# A collection of images
image_data2 = Openseadragon::Info.new(id: 'uri:to/info2.json')
openseadragon_collection_viewer [image_data, image_data2], crossOriginPolicy: false, html: { class: 'openseadragon-image' }
```

### Using an image resolver

```ruby
openseadragon_viewer('my_image_id', image_host: '/foo', html: {class: 'stuff'})
```

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

