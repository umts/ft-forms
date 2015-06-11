class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.string :name
      t.text :intro_text

      t.timestamps
    end
  end
end
