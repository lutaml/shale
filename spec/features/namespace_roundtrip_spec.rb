# frozen_striing_literal: true

require 'shale'
require 'shale/adapter/nokogiri'

class NamespaceWithNilPrefix  < Shale::Mapper
  attribute :output1, ::Shale::Type::String
  attribute :output2, ::Shale::Type::String

  xml do
    root 'collection'
    namespace 'http://ns1.com', nil

    map_attribute 'output1', to: :output1
    map_element 'output2', to: :output2
  end
end

class NamespaceWithPrefix  < Shale::Mapper
  attribute :output1, ::Shale::Type::String
  attribute :output2, ::Shale::Type::String

  xml do
    root 'collection'
    namespace 'http://ns1.com', "ns1"

    map_attribute 'output1', to: :output1
    map_element 'output2', to: :output2
  end
end

RSpec.describe "namespaces with prefixes" do
  before(:each) do
    Shale.xml_adapter = ::Shale::Adapter::Nokogiri
  end

  describe "namespace with nil prefix" do
    let(:xml) do
      <<~XML
        <collection xmlns="http://ns1.com" output1='A'>
          <output2>John</output2>
        </collection>
      XML
    end

    let(:object) do
      NamespaceWithNilPrefix.from_xml(xml)
    end

    it "should generate the correct xml" do
      expect(object.to_xml(pretty: true)).to be_equivalent_to(xml)
    end
  end

  describe "namespace with prefix" do
    let(:xml) do
      <<~XML
        <ns1:collection xmlns:ns1="http://ns1.com" output1='A'>
          <ns1:output2>John</ns1:output2>
        </ns1:collection>
      XML
    end

    let(:object) do
      NamespaceWithPrefix.from_xml(xml)
    end

    it "should generate the correct xml" do
      expect(object.to_xml(pretty: true)).to be_equivalent_to(xml)
    end
  end
end
