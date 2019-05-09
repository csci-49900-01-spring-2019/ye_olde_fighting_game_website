class StatsController < ApplicationController
  def index
    #require 'rest-client'
    #response = RestClient.get 'https://arcane-forest-85239.herokuapp.com'
    #response = RestClient.get 'https://arcane-forest-85239.herokuapp.com', {accept: :json}
    #puts "hello"
    #puts response.body
    #puts "goodbye"
    @stats = Stat.all
    #response.message, response.headers.inspect
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
    #require 'json'
    #require 'rest-client'
    #puts 'https://arcane-forest-85239.herokuapp.com/api/v1/users/' + params[:id]
    #r = RestClient.get('https://arcane-forest-85239.herokuapp.com/api/v1/users/' + params[:id])
    #puts r.body
    #parsed = JSON.parse(r.body)
    #puts parsed["username"]
    #puts parsed["avg_rank"]
    #puts parsed["kill_count"]
    #puts parsed["games_played"]
    #s = Stat.new
    #s.username = parsed["username"]
    #s.avg_rank = parsed["avg_rank"]
    #s.kill_count = parsed["kill_count"]
    #s.games_played = parsed["games_played"]
    #s.save
    #require 'rest-client'
    #r = RestClient.get('https://arcane-forest-85239.herokuapp.com/api/v1/users/1')
    #puts response.body
    #@stat = response.body
    #@stat.save
    #redirect_to @stat
    #@stat = Stat.new
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

  def refresh
    Stat.destroy_all
    Stat.import
    redirect_to(:action => 'index')
  end

end
