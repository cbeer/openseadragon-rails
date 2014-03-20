module Openseadragon
  module OpenseadragonHelper

    # @param id [String] the image identifier
    # @param options [Hash] 
    # @option options [String] :id ('openseadragon1') HTML id
    # @option options [Hash] :html HTML attributes
    # @option options [String] :prefixUrl
    # @option options [Array] :tileSources ([])
    # @option options [Hash] :options_with_raw_js
    def openseadragon_collection_viewer(ids_or_images, options={})
      html_options = (options[:html] or {})
      html_options[:id] = (options[:id] or 'openseadragon1')

      tile_sources = ids_or_images.zip((options[:tileSources] or [])).map do |id_or_image, opts|
        image_options(id_or_image, opts)
      end

      collection_options = {
        id: html_options[:id],
        prefixUrl: '/assets/openseadragon/',
        tileSources: tile_sources,
      }.deep_merge(options.except(:html, :tileSources))

      js_options = options_to_js(collection_options.except(:options_with_raw_js),
                                 collection_options[:options_with_raw_js])

      js =<<-EOF
        function initOpenSeadragon() {
          OpenSeadragon(#{js_options});
        }
        window.onload = initOpenSeadragon;
        document.addEventListener("page:load", initOpenSeadragon); // Initialize when using turbolinks
      EOF
      content_tag(:div, '', html_options) + javascript_tag(js)
    end

    # converts a ruby hash to a javascript object without stringifying the raw_js_keys
    # so you can put js variables in there
    def options_to_js(options, raw_js_keys=[])
      normal = options.except(*raw_js_keys).stringify_keys.map do |k, v|
        val = if v.is_a?(Hash) or v.is_a?(Array)
                JSON.pretty_generate(v)
              else
                json_dump(v)
              end
        k.to_s.inspect + ": " + val
      end
      raw_js = options.slice(*raw_js_keys).map{|k, v| k.to_s + ": " + v.to_s}
      "{\n" + (normal + raw_js).join(",\n") + "}"
    end


    # This hack is necessary for ruby 1.9.3. Just use JSON.dump(val) if Ruby >= 2.0
    if RUBY_VERSION < "2.0.0"
      def json_dump(val)
        case val
        when String
          val.inspect
        when Symbol
          val.to_s.inspect
        else
          raise ArgumentError, "Unexpected value #{val.inspect}"
        end
      end
    else
      def json_dump(val)
        JSON.dump(val)
      end
    end

    # @param id_or_image [String,Image] the image identifier or an image object
    # @param options [Hash] 
    # @option options [String] :html_id HTML id
    # @option options [String] :prefix_url
    # @option options [String] :image_host
    # @option options [String] :tile_width
    # @option options [String] :tile_height
    def openseadragon_viewer(id_or_image, options={})
      opts = {}
      opts[:id] = options[:html_id] if options[:html_id]
      opts[:prefixUrl] = options[:prefix_url] if options[:prefix_url]
      opts[:tileSources] = [options.slice(:image_host, :tile_width, :tile_height)]
      opts.deep_merge!(options.except(:html_id, :prefix_url, :image_host, :tile_width, :tile_height))
      openseadragon_collection_viewer([id_or_image], opts)
    end

    private

    # @param id_or_image [String,Image] the image identifier or an image object
    # @param options [Hash] 
    def image_options(id_or_image, options)
      options ||= {}
      image = case id_or_image
        when String
          image_options(Image.find(id_or_image), options)
        when Image
          id_or_image.to_tilesource.merge(options)
        when Info
          id_or_image.to_tilesource
        end
    end
  end
end
