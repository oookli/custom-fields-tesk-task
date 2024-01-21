# frozen_string_literal: true

class MakeNameAndInternalNameUniqueForUserCustomField < ActiveRecord::Migration[7.1]
  def change
    add_index :user_custom_fields, %i[name internal_name], unique: true
  end
end
