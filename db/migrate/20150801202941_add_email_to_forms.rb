class AddEmailToForms < ActiveRecord::Migration[4.2]
  def change
    add_column :forms, :email, :string
  end
end
