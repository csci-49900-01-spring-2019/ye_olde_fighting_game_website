class Stat < ApplicationRecord
  def self.import
    require 'json'
    require 'rest-client'
    response = RestClient.get 'https://arcane-forest-85239.herokuapp.com', {:Authorization => session[:current_user_id][:auth_token]}
    parsed = JSON.parse(response.body)
    user_data = parsed[0]
    for i in 0..parsed.size-1
      puts parsed[i]["username"]
      puts parsed[i]["avg_rank"]
      puts parsed[i]["kill_count"]
      puts parsed[i]["games_played"]
      s = Stat.new
      s.username = parsed[i]["username"]
      s.avg_rank = parsed[i]["avg_rank"]
      s.kill_count = parsed[i]["kill_count"]
      s.games_played = parsed[i]["games_played"]
      s.save
    end
  end

  def self.clear
    num = 1
    done = false
    until done
      begin
        @stat = Stat.find(num)
      rescue ActiveRecord::RecordNotFound => e
        done = true
      else
        @stat.destroy
      end
    end
  end

end
