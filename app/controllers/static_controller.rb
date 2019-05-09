class StaticController < ApplicationController
  def show
    @static = render params[:page]
  end

  def instructions
  end

  def twofactor
    @user = User.find params[:user_id]
    if @user.verification_code == params[:verification_code]
      @user.confirm!
      session[:authenticated] = true

      flash[:notice] = "Welcome #{@user.username}. The Adventure Begins!"
      redirect_to root_path
    else
      flash.now[:error] = "Verification code is incorrect."
      render :new
    end
  end
end
