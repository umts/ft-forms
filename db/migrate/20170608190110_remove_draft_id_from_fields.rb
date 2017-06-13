class RemoveDraftIdFromFields < ActiveRecord::Migration[5.1]
  def change
    remove_column :fields, :form_draft_id
  end
end
