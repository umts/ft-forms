class CreateForms < ActiveRecord::Migration[4.2]
  def change
    create_table :forms do |t|
      t.string :name
      t.text :intro_text

      t.timestamps
    end
  end
end
