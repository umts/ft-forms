class AddReplytoToForms < ActiveRecord::Migration[4.2]
  def change
    add_column :forms, :reply_to, :string
  end
end
