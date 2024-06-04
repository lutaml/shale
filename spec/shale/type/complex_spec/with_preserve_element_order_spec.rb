# frozen_string_literal: true

require 'shale'
require 'shale/error'

require 'shale/adapter/nokogiri'

class WithPreserveOrder < Shale::Mapper
  attribute :one, Shale::Type::String, collection: true
  attribute :two, Shale::Type::String, collection: true

  xml do
    root "with-order-preserve"
    preserve_element_order true

    map_element 'one', to: :one
    map_element 'two', to: :two
  end
end

class WithoutPreserveOrder < Shale::Mapper
  attribute :one, Shale::Type::String, collection: true
  attribute :two, Shale::Type::String, collection: true

  xml do
    root "without-order-preserve"

    map_element 'one', to: :one
    map_element 'two', to: :two
  end
end

RSpec.describe Shale::Type::Complex do
  before(:each) do
    Shale.xml_adapter = Shale::Adapter::Nokogiri
  end

  context "with preserve order" do
    let(:xml) do
      <<~XML.strip
        <with-order-preserve>
          <one>aaa</one>
          <two>bbb</two>
          <one>ccc</one>
          <two>ddd</two>
        </with-order-preserve>
      XML
    end

    describe "test element order" do
      it "should work" do
        expect(WithPreserveOrder.from_xml(xml).to_xml(pretty: true).strip).to eq(xml)
      end
    end
  end

  context "without preserve order" do
    describe "test element order" do
      let(:xml) do
        <<~XML
          <without-order-preserve>
            <one>aaa</one>
            <two>bbb</two>
            <one>ccc</one>
            <two>ddd</two>
          </without-order-preserve>
        XML
      end

      let(:expected_output) do
        <<~XML.strip
          <without-order-preserve>
            <one>aaa</one>
            <one>ccc</one>
            <two>bbb</two>
            <two>ddd</two>
          </without-order-preserve>
        XML
      end

      it "should work" do
        expect(WithoutPreserveOrder.from_xml(xml).to_xml(pretty: true).strip).to eq(expected_output)
      end
    end
  end
end
