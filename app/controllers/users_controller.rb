class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the Sample App, #{@user.name}!"
      redirect_to user_path(@user.id)
    else
      render 'new'
    end
  end
end
