class CreateFormDrafts < ActiveRecord::Migration[4.2]
  def change
    create_table :form_drafts do |t|
      t.string :name
      t.text :intro_text
      t.references :form
      t.timestamps
    end
  end
end
