require 'spec_helper'

describe Openseadragon::OpenseadragonHelper do
  before do
    module SpecResolver
      def self.find(id)
        Openseadragon::Image.new({ id: id }.merge(data(id)))
      end

      def self.data(id)
        { 'world' =>  {height: 400, width: 800},
          'irises' => {height: 3282, width: 4264}}[id]
      end
    end
    Openseadragon::Image.file_resolver = SpecResolver
  end

  it "should draw the single item viewer" do
    out = openseadragon_viewer('world', image_host: '/foo', html: {class: 'stuff'})
    out.should == '<div class="stuff" id="openseadragon1" /><script>
//<![CDATA[
        function initOpenSeadragon() {
          OpenSeadragon({
"id": "openseadragon1",
"prefixUrl": "/assets/openseadragon/",
"tileSources": [
  {
    "identifier": "world",
    "width": 800,
    "height": 400,
    "scale_factors": [
      1,
      2,
      3,
      4,
      5
    ],
    "formats": [
      "jpg",
      "png"
    ],
    "qualities": [
      "native",
      "bitonal",
      "grey",
      "color"
    ],
    "profile": "http://library.stanford.edu/iiif/image-api/compliance.html#level3",
    "tile_width": 1024,
    "tile_height": 1024,
    "image_host": "/foo"
  }
]});
        }
        window.onload = initOpenSeadragon;
        document.addEventListener("page:load", initOpenSeadragon); // Initialize when using turbolinks

//]]>
</script>'
  end

  it "should draw the single item viewer for an info.json source" do
    out = openseadragon_viewer(Openseadragon::Info.new(id: 'uri:to/info.json'))
    expect(out).to match '' +'
"tileSources": \[
  "uri:to/info.json"
\]\}\);'

  end

  it "should not crash when there's no tileSources" do
    openseadragon_collection_viewer(['world', 'irises'], {extraOption: :some_stuff})
    openseadragon_collection_viewer(['world', 'irises'],
                                    {extraOption: :some_stuff,
                                     rawOption: "(1 + 1)",
                                     options_with_raw_js: [:rawOption]})
  end

  it "should draw the collection viewer" do
    out = openseadragon_collection_viewer(['world', 'irises'],
                                          {tileSources: [{profile: :foo}, {profile: :bar}],
                                           extraOption: :some_stuff,
                                           rawOption: "(1 + 1)",
                                           options_with_raw_js: [:rawOption]})
    out.should == '<div id="openseadragon1" /><script>
//<![CDATA[
        function initOpenSeadragon() {
          OpenSeadragon({
"id": "openseadragon1",
"prefixUrl": "/assets/openseadragon/",
"tileSources": [
  {
    "identifier": "world",
    "width": 800,
    "height": 400,
    "scale_factors": [
      1,
      2,
      3,
      4,
      5
    ],
    "formats": [
      "jpg",
      "png"
    ],
    "qualities": [
      "native",
      "bitonal",
      "grey",
      "color"
    ],
    "profile": "foo",
    "tile_width": 1024,
    "tile_height": 1024,
    "image_host": "/image-service"
  },
  {
    "identifier": "irises",
    "width": 4264,
    "height": 3282,
    "scale_factors": [
      1,
      2,
      3,
      4,
      5
    ],
    "formats": [
      "jpg",
      "png"
    ],
    "qualities": [
      "native",
      "bitonal",
      "grey",
      "color"
    ],
    "profile": "bar",
    "tile_width": 1024,
    "tile_height": 1024,
    "image_host": "/image-service"
  }
],
"extraOption": "some_stuff",
rawOption: (1 + 1)});
        }
        window.onload = initOpenSeadragon;
        document.addEventListener("page:load", initOpenSeadragon); // Initialize when using turbolinks

//]]>
</script>'
  end
end
