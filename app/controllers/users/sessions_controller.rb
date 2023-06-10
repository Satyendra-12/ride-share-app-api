class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_user!
  respond_to :json

  def respond_with(resource, options={})
    if current_user.nil?
      render json:{
        status: { code: 400, error: 'Error occurred while signing in'}
      }, status: :bad_request
    else
      render json: {
        status: { code: 200, message: 'User Signed in successfully', data: current_user }
      }, status: :ok
      end
  end

  def givenRating
    @ratings = Rating.where(giver:current_user.id)
    if @ratings
      render json:{status:200,data:@ratings}
    else
      render json:{error:"No Rating given yet"}
    end
  end

  def showprofile
    @user = User.find_by(id: params[:id])
    @ratings = Rating.where(receiver: @user.id)
    @rating_average = @ratings.average(:rating)

    if @user 
      render json: { data: @user, average: @rating_average, totalrating: @ratings.length, image_url: @user.image.present? ? url_for(@user.image) : nil }
    end
  end

  def recievedRating
    @ratings = Rating.where(receiver:current_user.id)
    @rating_average = @ratings.average(:rating)
    @ratings_group = @ratings.group(:rating).count
    
    if @ratings.length >0
      render json:{status:200,average:@rating_average,groups:@ratings_group,data:@ratings}
    else
      render json:{error:"No rating are received yet"}
    end
  end
 

  def respond_to_on_destroy
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],Rails.application.credentials.fetch(:secret_key_base)).first
    current_user = User.find(jwt_payload['sub'])
    if current_user
      render json: {
        status: 200,
        message: "Signed out successfully"
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "User has no active session"
      }, status: :unauthorized
    end
  end
end
