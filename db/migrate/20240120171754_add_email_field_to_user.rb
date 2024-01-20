# frozen_string_literal: true

class AddEmailFieldToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :email, :string, null: false
  end
end
