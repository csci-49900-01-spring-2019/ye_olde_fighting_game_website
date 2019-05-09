class StatsController < ApplicationController
  def index
    @stats = Stat.all
  end

  def show
    begin
      @stat = Stat.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      print e
      redirect_to(:action => 'index')
    end
  end

  def new

  end

  def create
    require 'rest-client'
    response = RestClient.get 'https://arcane-forest-85239.herokuapp.com'
    puts "hello"
    puts response.body, response.code
    puts "goodbye"
    @stat = response.body
    @stat.save
    redirect_to @stat
  end

  def destroy
    @stats = Stat.find(params[:id])
    @stat.destroy

    redirect_to stats_path
  end

  #def refresh
  #  Stat.destroy_all
  #  Stat.import
  #  redirect_to(:action => 'index')
  #end

  def refresh
    Stat.destroy_all
    require 'json'
    require 'rest-client'
    puts session
    puts "hello"
    puts session[:auth_token]
    puts "bye"
    response = RestClient.get 'https://arcane-forest-85239.herokuapp.com', {:Authorization => session[:auth_token]}
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
    redirect_to(:action => 'index')
  end

end
