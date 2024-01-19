class UserCustomField < ApplicationRecord
  belongs_to :user, dependant: :delete_all
  validates :name, :internal_name, :type, presence: true

  before_validation :populate_internal_name

  enum type: {
    text: 0,
    number: 1,
    select: 2,
    multi_select: 3
  }

  private

  def populate_internal_name
    self.internal_name = internal_name.parameterize(separator: '_').underscore
  end
end
