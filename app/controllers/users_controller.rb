class UsersController < ApplicationController
  require 'twilio-ruby'
  #ATTRIBUTE_WHITELIST = [
  #  :first_name,
  #  :last_name,
  #  :email,
  #  :phone_number,
  #  :password_confirmation,
  #  :password
  #]

  def index
    #require 'rest-client'
    #response = RestClient.get 'https://arcane-forest-85239.herokuapp.com'
    #response = RestClient.get 'https://arcane-forest-85239.herokuapp.com', {accept: :json}
    #puts "hello"
    #puts response.body
    #puts "goodbye"
    @users = User.all
    #response.message, response.headers.inspect
  end

  def show
    @user = User.find(params[:id])
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

  #def create
  #render plain: params[:article].inspect
  #end

module CodeGenerator
  def self.generate
    rand(100000...999999).to_s
  end
end

module MessageSender
  def self.send_code(phone_number, code)
    account_sid = 'ACbcfa8332d9c274b270427ec56a13c522'
    auth_token  = '643456091274ca1b8c24a0c44a07f7df'
    client = Twilio::REST::Client.new(account_sid, auth_token)

    message = client.messages.create(
      from:  13479707167,
      to:    phone_number,
      body:  code
    )

    message.status == 'queued'
  end
end

module ConfirmationSender
  def self.send_confirmation_to(user)
    verification_code = CodeGenerator.generate
    user.update(verification_code: verification_code)
    #MessageSender.send_code(user.info, verification_code)
  end
end