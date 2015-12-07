class AddReplytoToForms < ActiveRecord::Migration
  def change
    add_column :forms, :reply_to, :string
  end
end
