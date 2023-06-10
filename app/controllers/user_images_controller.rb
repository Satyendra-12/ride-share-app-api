class UserImagesController < ApplicationController
  
  before_action :only => [:update]
  def show
      user = current_user
      render json: { 
          status: {code: 200},
          data: {
              image_url: url_for(user.image)
          }

      }, status: :ok
  end
      
  
  def update
      user = current_user
      if user.image.attach(params[:image])
          render json: { 
          status: {code: 200, message: 'Image successfully updated'},
          data: {
          user: user,
          image_url: url_for(user.image)
          }
      }
      else
          render json: { 
          status: {code: 422, message: 'must be a JPEG or PNG file'}
          }, status: :unprocessable_entity
      end
  end
        
end