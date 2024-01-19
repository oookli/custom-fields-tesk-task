class UserCustomField < ApplicationRecord
  belongs_to :user, dependent: :delete
  validates :name, :internal_name, :type, presence: true

  before_validation :populate_internal_name

  enum type: {
    text: 0,
    number: 1,
    # the "select" name is reserved by Active Record, so as alternative name is dropdown here
    dropdown: 2,
    # multi-select
    multi_dropdown: 3
  }

  private

  def populate_internal_name
    self.internal_name = internal_name.parameterize(separator: '_').underscore
  end
end
