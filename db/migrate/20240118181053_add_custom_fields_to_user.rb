class AddCustomFieldsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :custom_fields, :jsonb
  end
end
