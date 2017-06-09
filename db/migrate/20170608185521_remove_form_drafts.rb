class RemoveFormDrafts < ActiveRecord::Migration[5.1]
  def change
    drop_table :form_drafts
  end
end
