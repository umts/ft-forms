class AddEmailToFormDrafts < ActiveRecord::Migration
  def change
    add_column :form_drafts, :email, :string
  end
end
