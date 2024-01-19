class UserCustomField < ApplicationRecord
  belongs_to :user, dependent: :delete
  validates :name, :internal_name, :field_type, presence: true

  before_validation :populate_internal_name

  enum field_type: {
    text: 'text',
    number: 'number',
    # the "select" name is reserved by Active Record, so as alternative name is dropdown here
    dropdown: 'select',
    multi_dropdown: 'multi-select'
  }

  private

  def populate_internal_name
    self.internal_name = name&.parameterize(separator: '_')&.underscore
  end
end
