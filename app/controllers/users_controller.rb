class UsersController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
 
 # POST /register
  def register
    @user = User.create(user_params)
   if @user.save
    response = { message: 'User created successfully'}
    render json: response, status: :created 
    SubscriptionMailer.welcome_email(@user).deliver_now
   else
    render json: @user.errors, status: :bad
   end 
  end


  def unregister
    @user = User.where(email: params[:email]).destroy_all 
    response = { message: 'User removed successfully'}
    render json: response, status: :no_content 
    UnsubscriptionMailer.good_bye_email(@user).deliver_now
  end


  private

  def user_params
    params.permit(
      :email,
      :password
    )
  end
end