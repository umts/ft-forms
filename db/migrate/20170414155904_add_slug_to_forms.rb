class AddSlugToForms < ActiveRecord::Migration[4.2]
  def change
    add_column :forms, :slug, :string
  end
end
