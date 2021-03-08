class AddUniqueIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :fields, [:form_id, :number], unique: true
    add_index :fields, [:form_draft_id, :number], unique: true
    add_index :forms, :name, unique: true
    add_index :form_drafts, [:user_id, :form_id], unique: true
    add_index :users, :spire, unique: true
  end
end
