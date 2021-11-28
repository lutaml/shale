# frozen_string_literal: true

require 'shale/mapping/key_value'

RSpec.describe Shale::Mapping::KeyValue do
  describe '#keys' do
    it 'returns keys hash' do
      obj = described_class.new
      expect(obj.keys).to eq({})
    end
  end

  describe '#map' do
    it 'adds mapping to keys hash' do
      obj = described_class.new
      obj.map('foo', to: :bar)
      expect(obj.keys).to eq('foo' => :bar)
    end
  end

  describe '#initialize_dup' do
    it 'duplicates keys instance variable' do
      original = described_class.new
      original.map('foo', to: :bar)

      duplicate = original.dup
      duplicate.map('baz', to: :qux)

      expect(original.keys).to eq('foo' => :bar)
      expect(duplicate.keys).to eq('foo' => :bar, 'baz' => :qux)
    end
  end
end