class RatingsController < ApplicationController
  before_action :authenticate_user!
  def ratings
      @passengerRating = Passenger.find_by(publish_id:rate_params[:rideid],user_id:current_user.id)
      @driverRating = Publish.find_by(driver_id:current_user.id)
      @ride = Publish.find_by(id: rate_params[:rideid])
      if @ride.nil?
          render json: { error: "No such ride exists" }, status: :not_found
      end
      @rides = Passenger.where(publish_id:rate_params[:rideid])
      if @passengerRating.nil? and @driverRating.nil?
          render json: {error:"You cannot Rate until you rided that ride"} 
      elsif  @driverRating.nil? and @ride.driver_id != rate_params[:receiver]
          render json: {error: "As a passenger you can only rate driver."}
      elsif @passengerRating.nil?
          @rides.each do |ride|
              if ride.user_id == rate_params[:receiver]
                  @rating = Rating.new(rate_params)
                  if @rating.save
                      render json:{status:200,message:"Thank You For Rating!"}
                  else
                      render json: {error:"Unable To Rate!"}
                  end
              else 
                  render json: {error:"As a driver you can only rate passengers."}
              end
          end
      else
          @rating = Rating.new(rate_params)
          if @rating.save
              render json:{status:200,message:"Thank You For Rating!"}
          else
              render json: {error:"Unable To Rate!"}
          end
      end
    end
  private

  def rate_params
      params.require(:rating).permit(:rating,:comment,:rideid,:receiver).merge(giver:current_user.id)
  end

end