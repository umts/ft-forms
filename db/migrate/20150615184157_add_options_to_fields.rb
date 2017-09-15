class AddOptionsToFields < ActiveRecord::Migration[4.2]
  def change
    add_column :fields, :options, :text
  end
end
