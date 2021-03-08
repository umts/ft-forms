class AddDefaultToUserStaff < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :staff, from: nil, to: false
  end
end
