class AddReplytoToFormDrafts < ActiveRecord::Migration[4.2]
  def change
    add_column :form_drafts, :reply_to, :string
  end
end
