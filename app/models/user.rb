# frozen_string_literal: true

class User < ApplicationRecord
  after_initialize :add_custom_fields
  before_validation :add_custom_fields_validations

  validates_presence_of :email
  validates_uniqueness_of :email

  # this is a hack to support new and create with custom attributes, probably it's not a big deal to reinit
  # store_accessor again on the after_initialize hook
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
          validates custom_field.internal_name, allow_nil: true, format: { with: /\d/, message: 'is not a number' }
        when 'dropdown', 'multi_dropdown'
          validates custom_field.internal_name, allow_nil: true, inclusion: { in: custom_field.options }
        end
      end
    end
  end
end
