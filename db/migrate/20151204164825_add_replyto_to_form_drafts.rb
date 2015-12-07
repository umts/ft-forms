class AddReplytoToFormDrafts < ActiveRecord::Migration
  def change
    add_column :form_drafts, :reply_to, :string
  end
end
