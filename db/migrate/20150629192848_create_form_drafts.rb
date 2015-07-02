class CreateFormDrafts < ActiveRecord::Migration
  def change
    create_table :form_drafts do |t|
      t.string :name
      t.text :intro_text
      t.references :form
      t.timestamps
    end
  end
end
