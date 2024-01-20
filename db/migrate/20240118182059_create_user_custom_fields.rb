# frozen_string_literal: true

class CreateUserCustomFields < ActiveRecord::Migration[7.1]
  def change
    create_table :user_custom_fields do |t|
      t.string :name, null: false
      t.string :internal_name, null: false
      t.string :field_type, default: 'text', null: false

      t.timestamps
    end
  end
end
