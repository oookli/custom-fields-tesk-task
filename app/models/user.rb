# frozen_string_literal: true

class User < ApplicationRecord
  before_validation :add_custom_fields_validations

  def initialize(attributes = {})
    add_custom_fields

    super(attributes)
  end

  private

  def add_custom_fields
    UserCustomField.all.each do |custom_field|
      singleton_class.class_eval { store_accessor :custom_fields, custom_field.internal_name }
    end
  end

  def add_custom_fields_validations
    UserCustomField.all.each do |custom_field|
      singleton_class.class_eval do
        case custom_field.field_type
        when 'number'
          validates_numericality_of custom_field.internal_name, only_numeric: true, allow_nil: true
        # when 'text'
        #   validates_presence_of custom_field.internal_name, allow_nil: true
        end
      end
    end
  end
end
