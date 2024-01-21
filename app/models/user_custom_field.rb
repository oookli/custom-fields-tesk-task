# frozen_string_literal: true

class UserCustomField < ApplicationRecord
  validates :name, :internal_name, :field_type, presence: true
  validates_uniqueness_of :name, scope: :internal_name

  before_validation :populate_internal_name

  enum :field_type, {
    text: 'text',
    number: 'number',
    # the "select" name is reserved by Active Record, so as alternative name is dropdown here
    dropdown: 'select',
    multi_dropdown: 'multi-select'
  }, validate: true

  validates_absence_of :options, unless: :field_type_dropdown?
  validates_presence_of :options, if: :field_type_dropdown?

  private

  def populate_internal_name
    self.internal_name = name&.parameterize(separator: '_')&.underscore
  end

  def field_type_dropdown?
    %w[dropdown multi_dropdown].include? field_type
  end
end
