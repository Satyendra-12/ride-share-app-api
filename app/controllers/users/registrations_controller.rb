class Users::RegistrationsController < Devise::RegistrationsController
  
  respond_to :json


  def respond_with(resource, options = {})
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up successfully', data: resource },
      }, status: :ok
    else
      render plain: resource.errors.full_messages.first, status: :unprocessable_entity
    end
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: {
        status: { code: 200, message: 'User updated successfully', data: user },
        }
    else
      render json: {
        status: { code: 422, message: 'User could not be updated', errors: user.errors.full_messages }
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => error
    render json: { error: error.message }, status: :unauthorized
  end



  
  def destroy
    user = current_user
    user.destroy
    render json: { status: { code: 200, message: 'User deleted successfully' } }
  rescue ActiveRecord::RecordNotFound => error
    render json: { error: error.message }, status: :unauthorized
  end

  def show
    if current_user.present?
      render json: {
        status: { code: 200, data: current_user, image_url: current_user.image.attached? ? url_for(current_user.image) : nil }
      }, status: :ok
    else
      render json: { errors: 'User not found' }, status: :not_found
    end
  end
  
  
  private
  
  def sign_up_params
    params.require(:user).permit(:email, :first_name, :last_name, :dob, :title, :password, :phone_number)
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :bio, :postal_address, :title, :dob, :travel_preferences, :phone_number, :average_rating, :image_url)
  end

end 