class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to root_path
    end
  end

  def create
    #puts r.history
    require 'rest-client'
    #puts params[:session][:username]
    #puts params[:session][:password]
    #user = User.find_by(username: params[:session][:username].downcase)
    begin
      resp = RestClient.post 'https://arcane-forest-85239.herokuapp.com/auth/login', {'username' => params[:session][:username],'password' => params[:session][:password]}.to_json, {content_type: :json, accept: :json}
    rescue RestClient::Unauthorized, RestClient::Forbidden => err
      flash.now[:danger] = 'Wrong username or password!'
      render 'new'
    else
      parsed = JSON.parse(resp.body)
      puts parsed["auth_token"]
      params[:session][:auth_token] = parsed["auth_token"]
      session[:auth_token] = parsed["auth_token"]
      response = RestClient.get 'https://arcane-forest-85239.herokuapp.com', {:Authorization => params[:session][:auth_token]}
      parsed = JSON.parse(response.body)
      user_data = parsed[1]
      for i in 0..parsed.size-1
        if parsed[i]["username"] == params[:session][:username]
          user_data = parsed[i]
          puts parsed[i]
          break
        end
      end
      puts parsed
      user = User.find_by(username: params[:session][:username].downcase)
      if user #if the user is already locally stored
        user.update(avg_rank: user_data["avg_rank"], kill_count: user_data["kill_count"], games_played: user_data["games_played"])
        log_in user
        redirect_to user
      else
        response = RestClient.get 'https://arcane-forest-85239.herokuapp.com', {:Authorization => params[:session][:auth_token]}
        #response = RestClient.get 'https://arcane-forest-85239.herokuapp.com', {header: resp}
        user = User.create(username: params[:session][:username], avg_rank: user_data["avg_rank"], kill_count: user_data["kill_count"], games_played: user_data["games_played"])
        log_in user
        redirect_to user
      end
    end
  end

  def register
    if logged_in?
      redirect_to root_path
    end
  end

  def register_create
    require 'rest-client'
    #user = User.find_by(username: params[:session][:username].downcase)
    begin
      resp = RestClient.post 'https://arcane-forest-85239.herokuapp.com/signup', {'username' => params[:session][:username],'password' => params[:session][:password], 'password_confirmation' => params[:session][:password_confirmation]}.to_json, {content_type: :json, accept: :json}
    rescue RestClient::UnprocessableEntity => err
      flash.now[:danger] = 'An account with this username already exists.'
      render 'register'
    else
      parsed = JSON.parse(resp.body)
      puts parsed["auth_token"]
      params[:session][:auth_token] = parsed["auth_token"]
      user = User.find_by(username: params[:session][:username].downcase)
      if user #if the user is already locally stored
        user.update(avg_rank: 0.0, kill_count: 0, games_played: 0)
        log_in user
        redirect_to user
      else
        #response = RestClient.get 'https://arcane-forest-85239.herokuapp.com', {accept: :json}
        user = User.create(username: params[:session][:username], avg_rank: 0.0, kill_count: 0, games_played: 0)
        log_in user
        redirect_to user
      end
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
