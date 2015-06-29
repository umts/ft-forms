class AddFormDraftIdToFields < ActiveRecord::Migration
  def change
    add_column :fields, :form_draft_id, :integer
  end
end
