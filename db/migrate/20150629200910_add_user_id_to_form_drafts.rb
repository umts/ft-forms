class AddUserIdToFormDrafts < ActiveRecord::Migration[4.2]
  def change
    add_column :form_drafts, :user_id, :integer
  end
end
