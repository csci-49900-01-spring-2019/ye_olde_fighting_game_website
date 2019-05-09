class Stat < ApplicationRecord
  def self.import
    require 'json'
    require 'rest-client'
    num = 1
    done = false
    until done
      begin
        #puts 'https://arcane-forest-85239.herokuapp.com/api/v1/users/' + num.to_s
        r = RestClient.get('https://arcane-forest-85239.herokuapp.com/api/v1/users/' + num.to_s)
      rescue RestClient::NotFound => e
        done = true
      else
        puts r.body
        parsed = JSON.parse(r.body)
        puts parsed["username"]
        puts parsed["avg_rank"]
        puts parsed["kill_count"]
        puts parsed["games_played"]
        s = Stat.new
        s.username = parsed["username"]
        s.avg_rank = parsed["avg_rank"]
        s.kill_count = parsed["kill_count"]
        s.games_played = parsed["games_played"]
        num = num+1
        unless s.save
          done = true
        end
      end
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
