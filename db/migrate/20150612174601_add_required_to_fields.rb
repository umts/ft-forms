class AddRequiredToFields < ActiveRecord::Migration
  def change
    add_column :fields, :required, :boolean
  end
end
