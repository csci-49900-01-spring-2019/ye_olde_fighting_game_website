class AddKillCountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :kill_count, :integer
  end
end
