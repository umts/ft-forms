class AddRequiredToFields < ActiveRecord::Migration[4.2]
  def change
    add_column :fields, :required, :boolean
  end
end
