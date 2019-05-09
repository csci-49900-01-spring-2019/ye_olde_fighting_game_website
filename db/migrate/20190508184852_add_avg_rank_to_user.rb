class AddAvgRankToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :avg_rank, :float
  end
end
