# frozen_striing_literal: true

require 'shale'
require 'shale/adapter/nokogiri'

class Output3 < Shale::Mapper
  attribute :output4, ::Shale::Type::String

  xml do
    root 'output3'
    namespace 'http://ns3.com', "ns1"
    preserve_namespaces true

    map_element 'output4', to: :output4, namespace: "http://ns3.com", prefix: "ns1"
  end
end

class Output2 < Shale::Mapper
  attribute :output3, ::Output3

  xml do
    root 'output2'
    namespace 'http://ns2.com', "ns1"
    preserve_namespaces true

    map_element 'output3', to: :output3, namespace: "http://ns3.com", prefix: "ns1"
  end
end

class PreservingNamespaces < Shale::Mapper
  attribute :output1, ::Shale::Type::String
  attribute :output2, ::Output2

  xml do
    root 'collection'
    namespace 'http://ns1.com', "ns1"

    map_attribute 'output1', to: :output1
    map_element 'output2', to: :output2, namespace: "http://ns2.com", prefix: "ns1"
  end
end

class NotPreservingOutput3 < Shale::Mapper
  attribute :output4, ::Shale::Type::String

  xml do
    root 'output3'
    namespace 'http://ns3.com', "ns1"
    preserve_namespaces false

    map_element 'output4', to: :output4, namespace: "http://ns3.com", prefix: "ns1"
  end
end

class NotPreservingOutput2 < Shale::Mapper
  attribute :not_preserving_output3, ::NotPreservingOutput3

  xml do
    root 'output2'
    namespace 'http://ns2.com', "ns1"

    map_element 'output3', to: :not_preserving_output3, namespace: "http://ns3.com", prefix: "ns1"
  end
end

class NotPreservingNamespaces < Shale::Mapper
  attribute :output1, ::Shale::Type::String
  attribute :not_preserving_ouput2, ::NotPreservingOutput2

  xml do
    root 'collection'
    namespace 'http://ns1.com', "ns1"

    map_attribute 'output1', to: :output1
    map_element 'output2', to: :not_preserving_ouput2, namespace: "http://ns2.com", prefix: "ns1"
  end
end

RSpec.describe "namespaces with prefixes" do
  before(:each) do
    Shale.xml_adapter = ::Shale::Adapter::Nokogiri
  end

  subject(:xml) do
    <<~XML
      <ns1:collection xmlns:ns1="http://ns1.com" output1='A'>
        <ns1:output2 xmlns:ns1="http://ns2.com">
          <ns1:output3 xmlns:ns1="http://ns3.com">
            <ns1:output4>Jhon</ns1:output4>
          </ns1:output3>
        </ns1:output2>
      </ns1:collection>
    XML
  end

  describe "preserving namespaces" do

    let(:object) do
      PreservingNamespaces.from_xml(xml)
    end

    it "should generate the correct xml" do
      expect(object.to_xml(pretty: true)).to be_equivalent_to(xml)
    end
  end

  describe "not preserving namespaces" do
    let(:object) do
      NotPreservingNamespaces.from_xml(xml)
    end

    it "should generate the correct xml" do
      expect(object.to_xml(pretty: true)).not_to be_equivalent_to(xml)
    end
  end
end
