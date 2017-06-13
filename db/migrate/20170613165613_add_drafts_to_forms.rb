class AddDraftsToForms < ActiveRecord::Migration[5.1]
  def change
    add_column :forms, :draft_id, :integer
    add_column :forms, :published_at, :timestamp
    add_column :forms, :trashed_at, :timestamp
  end
end
