require 'spec_helper'

describe Openseadragon::Info do
  subject { Openseadragon::Info.new id: 'some-uri' }
  its(:to_tilesource) { should eq 'some-uri' }
end
