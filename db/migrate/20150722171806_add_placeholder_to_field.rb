class AddPlaceholderToField < ActiveRecord::Migration[4.2]
  def change
    add_column :fields, :placeholder, :string
  end
end
