class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  before_filter :not_signed_in, only: [:new, :create]

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 15)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.email == "zdrummond@gmail.com"
      @user.admin = TRUE
    end
    if @user.save
      sign_in @user
      if @user.email == "zdrummond@gmail.com"
        flash[:zach] = "Zachy! I've been expecting you! LEVELED UP TO ADMIN!"
      else
        flash[:success] = "Welcome to the Sample App, #{@user.name}!"
      end
      redirect_to user_path(@user.id)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 15)
  end

  def destroy
    if current_user?(User.find(params[:id]))
      redirect_to(root_path)
    else
      User.find(params[:id]).destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    end

  end

  private

  def not_signed_in
    unless !signed_in?
      redirect_to root_path
    end
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
end
