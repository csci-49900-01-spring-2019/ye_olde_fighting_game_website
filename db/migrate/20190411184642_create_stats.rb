class CreateStats < ActiveRecord::Migration[5.2]
  def change
    create_table :stats do |t|
      t.text :username
      t.float :avg_rank
      t.integer :kill_count
      t.integer :games_played

      t.timestamps
    end
  end
end
