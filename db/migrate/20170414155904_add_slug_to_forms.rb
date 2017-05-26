class AddSlugToForms < ActiveRecord::Migration
  def change
    add_column :forms, :slug, :string
  end
end
