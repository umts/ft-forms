class AddSomeOtherIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :form_drafts, :form_id
  end
end
