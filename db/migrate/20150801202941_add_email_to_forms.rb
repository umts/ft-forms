class AddEmailToForms < ActiveRecord::Migration
  def change
    add_column :forms, :email, :string
  end
end
