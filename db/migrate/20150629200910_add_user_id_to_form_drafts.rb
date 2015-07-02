class AddUserIdToFormDrafts < ActiveRecord::Migration
  def change
    add_column :form_drafts, :user_id, :integer
  end
end
