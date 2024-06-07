# frozen_string_literal: true

module Shale
  module Mapping
    module Descriptor
      # Class representing attribute mapping
      #
      # @api private
      class Dict
        # Return mapping name
        #
        # @return [String]
        #
        # @api private
        attr_reader :name

        # Return attribute name
        #
        # @return [Symbol]
        #
        # @api private
        attr_reader :attribute

        # Return receiver name
        #
        # @return [Symbol]
        #
        # @api private
        attr_reader :receiver

        # Return method symbol
        #
        # @return [Symbol]
        #
        # @api private
        attr_reader :method_from

        # Return method symbol
        #
        # @return [Symbol]
        #
        # @api private
        attr_reader :method_to

        # Return child attribute where the key will be mapped
        #
        # @return [Symbol]
        #
        # @api private
        attr_reader :child_mapping

        # Return group name
        #
        # @return [String]
        #
        # @api private
        attr_reader :group

        # Return schema hash
        #
        # @return [Hash]
        #
        # @api private
        attr_reader :schema

        # Initialize instance
        #
        # @param [String] name
        # @param [Symbol, nil] attribute
        # @param [Symbol, nil] receiver
        # @param [Hash, nil] methods
        # @param [Hash, nil] child_mapping
        # @param [String, nil] group
        # @param [true, false] render_nil
        # @param [Hash, nil] schema
        #
        # @api private
        def initialize(name:, attribute:, receiver:, methods:, group:, render_nil:, schema: nil, child_mapping: nil)
          @name = name
          @attribute = attribute
          @receiver = receiver
          @group = group
          @render_nil = render_nil
          @schema = schema
          @child_mapping = child_mapping

          if methods
            @method_from = methods[:from]
            @method_to = methods[:to]
          end
        end

        # Check render_nil
        #
        # @return [true, false]
        #
        # @api private
        def render_nil?
          @render_nil == true
        end
      end
    end
  end
end
