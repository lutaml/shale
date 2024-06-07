# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/adapter/csv'
require 'tomlib'

module ComplexSpec__ChildMapping # rubocop:disable Naming/ClassAndModuleCamelCase
  class Schema < Shale::Mapper
    attribute :id, Shale::Type::String
    attribute :path, Shale::Type::String
    attribute :name, Shale::Type::String
  end

  class ChildMappingClass < Shale::Mapper
   attribute :schemas, Schema, collection: true

    hsh do
      map 'schemas', to: :schemas,
                     map: {
                       id: :key,
                       path: [:path, :link],
                       name: [:path, :name]
                     }
    end

    json do
      map 'schemas', to: :schemas,
                     map: {
                       id: :key,
                       path: [:path, :link],
                       name: [:path, :name]
                     }
    end

    yaml do
      map 'schemas', to: :schemas,
                     map: {
                       id: :key,
                       path: [:path, :link],
                       name: [:path, :name]
                     }
    end

    toml do
      map 'schemas', to: :schemas,
                     map: {
                       id: :key,
                       path: [:path, :abc],
                       name: [:path, :name]
                     }
    end
  end
end

RSpec.describe Shale::Type::Complex do
  before(:each) do
    Shale.json_adapter = Shale::Adapter::JSON
    Shale.yaml_adapter = YAML
    Shale.toml_adapter = Tomlib
  end

  let(:mapper) { ComplexSpec__ChildMapping::ChildMappingClass }
  let(:schema) { ComplexSpec__ChildMapping::Schema }

  context 'with child_mapping' do
    let(:hash) do
      {
        "schemas" => {
          "foo" => {
            "path" => {
              "link" => "link one",
              "name" => "one",
            },
          },
          "abc" => {
            "path" => {
              "link" => "link two",
              "name" => "two",
            },
          },
          "hello" => {
            "path" => {
              "link" => "link three",
              "name" => "three",
            },
          },
        }
      }
    end

    let(:expected_ids) { ["foo", "abc", "hello"] }
    let(:expected_paths) { ["link one", "link two", "link three"] }
    let(:expected_names) { ["one", "two", "three"] }

    context "hash" do
      describe '.from_hash' do
        it 'create model according to hash' do
          instance = mapper.from_hash(hash)

          expect(instance.schemas.count).to eq(3)
          expect(instance.schemas.map(&:id)).to eq(expected_ids)
          expect(instance.schemas.map(&:path)).to eq(expected_paths)
          expect(instance.schemas.map(&:name)).to eq(expected_names)
        end
      end

      describe '.to_hash' do
        it 'converts objects to hash' do
          schema1 = schema.new(id: "foo", path: "link one", name: "one")
          schema2 = schema.new(id: "abc", path: "link two", name: "two")
          schema3 = schema.new(id: "hello", path: "link three", name: "three")

          instance = mapper.new(schemas: [schema1, schema2, schema3])

          expect(instance.to_hash).to eq(hash)
        end
      end
    end

    context "json" do
      let(:json) do
        hash.to_json
      end

      describe '.from_json' do
        it 'create model according to json' do
          instance = mapper.from_json(json)

          expect(instance.schemas.count).to eq(3)
          expect(instance.schemas.map(&:id)).to eq(expected_ids)
          expect(instance.schemas.map(&:path)).to eq(expected_paths)
          expect(instance.schemas.map(&:name)).to eq(expected_names)
        end
      end

      describe '.to_json' do
        it 'converts objects to json' do
          schema1 = schema.new(id: "foo", path: "link one", name: "one")
          schema2 = schema.new(id: "abc", path: "link two", name: "two")
          schema3 = schema.new(id: "hello", path: "link three", name: "three")

          instance = mapper.new(schemas: [schema1, schema2, schema3])

          expect(instance.to_json).to eq(json)
        end
      end
    end

    context "yaml" do
      let(:yaml) do
        hash.to_yaml
      end

      describe '.from_yaml' do
        it 'create model according to yaml' do
          instance = mapper.from_yaml(yaml)

          expect(instance.schemas.count).to eq(3)
          expect(instance.schemas.map(&:id)).to eq(expected_ids)
          expect(instance.schemas.map(&:path)).to eq(expected_paths)
          expect(instance.schemas.map(&:name)).to eq(expected_names)
        end
      end

      describe '.to_yaml' do
        it 'converts objects to yaml' do
          schema1 = schema.new(id: "foo", path: "link one", name: "one")
          schema2 = schema.new(id: "abc", path: "link two", name: "two")
          schema3 = schema.new(id: "hello", path: "link three", name: "three")

          instance = mapper.new(schemas: [schema1, schema2, schema3])

          expect(instance.to_yaml).to eq(yaml)
        end
      end
    end

    context "toml" do
      let(:toml) do
        <<~TOML
          [schemas.foo.path]
          abc = "link one"
          name = "one"

          [schemas.abc.path]
          abc = "link two"
          name = "two"

          [schemas.hello.path]
          abc = "link three"
          name = "three"
        TOML
      end

      describe '.from_toml' do
        it 'create model according to toml' do
          instance = mapper.from_toml(toml)

          expect(instance.schemas.count).to eq(3)
          expect(instance.schemas.map(&:id)).to eq(expected_ids)
          expect(instance.schemas.map(&:path)).to eq(expected_paths)
          expect(instance.schemas.map(&:name)).to eq(expected_names)
        end
      end

      describe '.to_toml' do
        it 'converts objects to toml' do
          schema1 = schema.new(id: "foo", path: "link one", name: "one")
          schema2 = schema.new(id: "abc", path: "link two", name: "two")
          schema3 = schema.new(id: "hello", path: "link three", name: "three")

          instance = mapper.new(schemas: [schema1, schema2, schema3])

          expect(instance.to_toml).to eq(toml)
        end
      end
    end
  end
end
