class AddEmailToFormDrafts < ActiveRecord::Migration[4.2]
  def change
    add_column :form_drafts, :email, :string
  end
end
