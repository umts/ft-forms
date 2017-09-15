class AddFormDraftIdToFields < ActiveRecord::Migration[4.2]
  def change
    add_column :fields, :form_draft_id, :integer
  end
end
