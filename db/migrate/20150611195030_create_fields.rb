class CreateFields < ActiveRecord::Migration[4.2]
  def change
    create_table :fields do |t|
      t.integer :number
      t.text :prompt
      t.string :data_type
      t.integer :form_id

      t.timestamps
    end
  end
end
