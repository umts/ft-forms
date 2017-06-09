class RemoveDraftIdFromFields < ActiveRecord::Migration[5.1]
  def change
    remove_column :fields, :draft_id
  end
end
