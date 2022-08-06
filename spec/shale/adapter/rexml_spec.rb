# frozen_string_literal: true

require 'rexml'
require 'shale/adapter/rexml'

RSpec.describe Shale::Adapter::REXML do
  describe '.load' do
    context 'with valid XML document' do
      it 'parses XML document' do
        doc = described_class.load('<foo></foo>')
        expect(doc.name).to eq('foo')
      end
    end

    context 'with invalid XML document' do
      it 'raises an error' do
        expect do
          described_class.load('<foo')
        end.to raise_error(Shale::ParseError)
      end
    end
  end

  describe '.dump' do
    let(:doc) do
      bar = ::REXML::Element.new('bar')
      bar.add_text('Hello')
      foo = ::REXML::Element.new('foo')
      foo.add_element(bar)
      doc = ::REXML::Document.new(nil, prologue_quote: :quote)
      doc.add_element(foo)
      doc
    end

    context 'with no params' do
      it 'generates XML document' do
        xml = described_class.dump(doc)
        expect(xml).to eq('<foo><bar>Hello</bar></foo>')
      end
    end

    context 'with pretty: true param' do
      it 'generates XML document and formats it' do
        xml = described_class.dump(doc, pretty: true)
        expected = <<~XML.gsub(/\n\z/, '')
          <foo>
            <bar>Hello</bar>
          </foo>
        XML

        expect(xml).to eq(expected)
      end
    end

    context 'with declaration: true param' do
      it 'generates XML document with declaration' do
        xml = described_class.dump(doc, declaration: true)
        expect(xml).to eq('<?xml version="1.0"?><foo><bar>Hello</bar></foo>')
      end
    end

    context 'with pretty: true and declaration: true param' do
      it 'generates XML document with declaration and formats it' do
        xml = described_class.dump(doc, pretty: true, declaration: true)
        expected = <<~XML.gsub(/\n\z/, '')
          <?xml version="1.0"?>
          <foo>
            <bar>Hello</bar>
          </foo>
        XML

        expect(xml).to eq(expected)
      end
    end
  end

  describe '.create_document' do
    it 'returns instance of Shale::Adapter::REXML::Document' do
      doc = described_class.create_document
      expect(doc.class).to eq(Shale::Adapter::REXML::Document)
    end
  end
end
