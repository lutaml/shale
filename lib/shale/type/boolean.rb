# frozen_string_literal: true

require_relative 'base'

module Shale
  module Type
    # Cast value to Boolean
    #
    # @api public
    class Boolean < Base
      FALSE_VALUES = [
        false,
        0,
        '0',
        'f',
        'F',
        'false',
        'FALSE',
        'off',
        'OFF',
      ].freeze

      # @param [any] value Value to cast
      #
      # @return [Boolean, nil]
      #
      # @api private
      def self.cast(value)
        !FALSE_VALUES.include?(value) unless value.nil?
      end
    end
  end
end
