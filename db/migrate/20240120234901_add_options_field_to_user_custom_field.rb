# frozen_string_literal: true

class AddOptionsFieldToUserCustomField < ActiveRecord::Migration[7.1]
  def change
    add_column :user_custom_fields, :options, :string, array: true
  end
end
