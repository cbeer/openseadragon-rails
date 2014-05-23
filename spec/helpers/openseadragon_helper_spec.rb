require 'spec_helper'

describe Openseadragon::OpenseadragonHelper do
  describe "#picture_tag" do
    context "without any sources" do
      it "should render an empty <picture>" do
        expect(helper.picture_tag).to have_selector 'picture'
      end
      
      it "should use provided options" do
        expect(helper.picture_tag a: 1).to have_selector 'picture[a="1"]'
      end
    end
    
    context "with two sources" do
      it "should include both sources" do
        response = helper.picture_tag 'image1.jpg', 'image2.jpg'
        expect(response).to have_selector 'picture source[src="image1.jpg"]'
        expect(response).to have_selector 'picture source[src="image2.jpg"]'
      end
      
      it "should use provided global options" do
        response = helper.picture_tag 'image1.jpg', 'image2.jpg', { a: 1 }, {b: 2}
        expect(response).to have_selector 'picture[b="2"]'
        expect(response).to have_selector 'picture source[src="image1.jpg"][a="1"]'
        expect(response).to have_selector 'picture source[src="image2.jpg"][a="1"]'
      end
      
    end
    
    context "with a source given as a hash" do
      it "should use the key of the hash for the src" do
        expect(helper.picture_tag ['image1.jpg' => { }]).to have_selector 'picture source[src="image1.jpg"]'
      end
      
      it "should use the attributes as options for the source tag" do
        expect(helper.picture_tag ['image1.jpg' => { a: 1}]).to have_selector 'picture source[src="image1.jpg"][a="1"]'
      end
      
      it "should merge the source-specific attributes with the global attributes" do
        expect(helper.picture_tag ['image1.jpg' => { a: 1}], {a: 2, b: 2}, { }).to have_selector 'picture source[src="image1.jpg"][a="1"][b="2"]'
      end
    end
  end
  
  describe "#openseadragon_picture_tag" do
    it "should mark the <picture> as an openseadragon tag" do
        expect(helper.openseadragon_picture_tag).to have_selector 'picture[data-openseadragon="true"]'
    end
    
    it "should pass simple strings through" do
      response = helper.openseadragon_picture_tag('image1.jpg', 'image2.jpg')
      expect(response).to have_selector 'picture source[src="image1.jpg"][media="openseadragon"]'
      expect(response).to have_selector 'picture source[src="image2.jpg"][media="openseadragon"]'
    end
    
    context "with tilesource objects" do
      it "should convert sources to tilesources" do
        source = double(to_tilesource: { a: 1})
        response = helper.openseadragon_picture_tag(source)
        expect(response).to have_selector 'picture source[src="openseadragon-tilesource"]'
        expect(response).to match /data-openseadragon="#{helper.escape_once({a: 1}.to_json)}"/
      end
    end
    
    context "with a source given as a hash" do
      before { allow(helper).to receive(:osd_asset_defaults).and_return({b: 6}) }

      it "should extract html options" do
        response = helper.openseadragon_picture_tag(['image1.jpg' => { html: { id: 'xyz' }}])
        expect(response).to have_selector 'picture source[src="image1.jpg"][id="xyz"]'
      end
      
      it "should pass the remaining options as encoded openseadragon options" do
        response = helper.openseadragon_picture_tag(['image1.jpg' => { a: 1}])
        expect(response).to have_selector 'picture source[src="image1.jpg"]'
        expect(response).to have_selector 'picture source[src="image1.jpg"][data-openseadragon]'
        expect(response).to match /data-openseadragon="#{helper.escape_once({b: 6, a: 1}.to_json)}"/
      end
      
      it "should merge a tilesource key with the options provided" do
        source = double(to_tilesource: { a: 1, b: 1})
        response = helper.openseadragon_picture_tag([source => { html: { id: 'xyz' }, b: 2, c: 3}])
        expect(response).to have_selector 'picture source[src="openseadragon-tilesource"]'
        expect(response).to have_selector 'picture source[src="openseadragon-tilesource"][id="xyz"]'
        expect(response).to match /data-openseadragon="#{helper.escape_once({b: 2, c: 3, a: 1}.to_json)}"/
      end
    end

    describe "#osd_asset_defaults" do
      subject { helper.send(:osd_asset_defaults) }
      its(['prefixUrl']) { should eq ''}
      its(['navImages']) { should eq(
        "zoomIn"=>{"REST"=>"/assets/openseadragon/zoomin_rest.png", "GROUP"=>"/assets/openseadragon/zoomin_grouphover.png", "HOVER"=>"/assets/openseadragon/zoomin_hover.png", "DOWN"=>"/assets/openseadragon/zoomin_pressed.png"},
        "zoomOut"=>{"REST"=>"/assets/openseadragon/zoomout_rest.png", "GROUP"=>"/assets/openseadragon/zoomout_grouphover.png", "HOVER"=>"/assets/openseadragon/zoomout_hover.png", "DOWN"=>"/assets/openseadragon/zoomout_pressed.png"},
        "home"=>{"REST"=>"/assets/openseadragon/home_rest.png", "GROUP"=>"/assets/openseadragon/home_grouphover.png", "HOVER"=>"/assets/openseadragon/home_hover.png", "DOWN"=>"/assets/openseadragon/home_pressed.png"},
        "fullpage"=>{"REST"=>"/assets/openseadragon/fullpage_rest.png", "GROUP"=>"/assets/openseadragon/fullpage_grouphover.png", "HOVER"=>"/assets/openseadragon/fullpage_hover.png", "DOWN"=>"/assets/openseadragon/fullpage_pressed.png"},
        "rotateleft"=>{"REST"=>"/assets/openseadragon/rotateleft_rest.png", "GROUP"=>"/assets/openseadragon/rotateleft_grouphover.png", "HOVER"=>"/assets/openseadragon/rotateleft_hover.png", "DOWN"=>"/assets/openseadragon/rotateleft_pressed.png"},
        "rotateright"=>{"REST"=>"/assets/openseadragon/rotateright_rest.png", "GROUP"=>"/assets/openseadragon/rotateright_grouphover.png", "HOVER"=>"/assets/openseadragon/rotateright_hover.png", "DOWN"=>"/assets/openseadragon/rotateright_pressed.png"},
        "previous"=>{"REST"=>"/assets/openseadragon/previous_rest.png", "GROUP"=>"/assets/openseadragon/previous_grouphover.png", "HOVER"=>"/assets/openseadragon/previous_hover.png", "DOWN"=>"/assets/openseadragon/previous_pressed.png"},
        "next"=>{"REST"=>"/assets/openseadragon/next_rest.png", "GROUP"=>"/assets/openseadragon/next_grouphover.png", "HOVER"=>"/assets/openseadragon/next_hover.png", "DOWN"=>"/assets/openseadragon/next_pressed.png"}
      )}

    end
  end
end
