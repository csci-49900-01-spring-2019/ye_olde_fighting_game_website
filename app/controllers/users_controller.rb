class UsersController < ApplicationController
  #require 'twilio-ruby'
  #ATTRIBUTE_WHITELIST = [
  #  :first_name,
  #  :last_name,
  #  :email,
  #  :phone_number,
  #  :password_confirmation,
  #  :password
  #]

  def index
    if (logged_in?)
      #@users = User.all
      #@users.each do |u|
      #  if (u != @current_user)
      #    u.destroy
      #  end
      #end
      #User.destroy_all
      require 'json'
      require 'rest-client'
      response = RestClient.get 'https://arcane-forest-85239.herokuapp.com', {:Authorization => session[:auth_token]}
      parsed = JSON.parse(response.body)
      user_data = parsed[0]
      for i in 0..parsed.size-1
        puts parsed[i]["username"]
        u = User.find_by(username: parsed[i]["username"])
        if (u == nil) #if the user doesn't exist
          puts parsed[i]["avg_rank"]
          puts parsed[i]["kill_count"]
          puts parsed[i]["games_played"]
          s = User.new
          s.id = parsed[i]["id"]
          s.username = parsed[i]["username"]
          s.avg_rank = parsed[i]["avg_rank"]
          s.kill_count = parsed[i]["kill_count"]
          s.games_played = parsed[i]["games_played"]
          s.save
        else
          u.avg_rank = parsed[i]["avg_rank"]
          u.kill_count = parsed[i]["kill_count"]
          u.games_played = parsed[i]["games_played"]
          u.save
        end
      end
      @users = User.all
    end
  end

  def show
    @user = User.find(params[:id])
    if (@user.games_played > 0)
      @data_exists = true
      r2 = RestClient.get 'https://arcane-forest-85239.herokuapp.com/api/v1/users?game_sessions=' + (params[:id]).to_s, {:Authorization => session[:auth_token]}
      puts 'https://arcane-forest-85239.herokuapp.com/api/v1/users?game_sessions=' + (params[:id]).to_s
      puts r2
      parsed = JSON.parse(r2.body)
      @size = parsed.size
      @parsed = parsed
      puts parsed[1]
      @game_id = parsed[1]["game_id"]
      @dealt = parsed[1]["total_damage_dealt"]
      @taken = parsed[1]["total_damage_taken"]
      @healing = parsed[1]["total_healing"]
      @kills = parsed[1]["num_kills"]
      @weapons = parsed[1]["weapons_collected"]
      puts parsed[1]["weapons_collected"]
    else
      @data_exists = false
    end
    #gs1 = GameSession.new(id, dealt, taken, healing, kills, weapons)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
    end
  end

  def destroy
    @users = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end


  #    require 'rest-client'
  #    begin
  #      resp = RestClient.post 'https://arcane-forest-85239.herokuapp.com/auth/login', {'username' => params[:session][:username],'password' => params[:session][:password],'password_confirmation' => params[:session][:password]}.to_json, {content_type: :json, accept: :json}
  #    rescue RestClient::Unauthorized, RestClient::Forbidden => err
  #      puts 'Access denied'
  #      render 'new'
  #    else
  #      puts 'It worked!'

  #      log_in user
  #      redirect_to user
  #    end
  #    RestClient.post 'https://arcane-forest-85239.herokuapp.com', {username: @user.username, password: 'two'}
  #    response = RestClient.get 'https://arcane-forest-85239.herokuapp.com'
      #ConfirmationSender.send_confirmation_to(@user)
      #redirect_to twofactor_path + '/' + string(@user.id)
  #  else
  #    render :new
  #  end
  #end

  private
  def user_params
    params.require(:user).permit([:username])
  end

end

#class GameSession
#   def initialize(id, dealt, taken, healing, kills, weapons)
#      @game_id = id
#      @damage_dealt = dealt
#      @damage_taken = taken
#      @amount_healed = healing
#      @game_kills = kills
#      @num_weapons_collected = weapons
#   end
#end
