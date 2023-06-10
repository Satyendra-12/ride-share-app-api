class PassengersController < ApplicationController
  before_action :authenticate_user!
  
  def book_publish
    publish = Publish.find_by(id: params[:passenger][:publish_id])
    passenger = Passenger.find_by(publish_id: publish.id)
  
    if publish.driver_id == current_user.id
      render json: { error: "Driver can't book his own ride." }
    elsif passenger.status == "Booked"
      render json: { error: "You can't book this ride again." }
    elsif publish && publish.passengers_count > 0
      seats = params[:passenger][:seats].to_i
      if publish.passengers_count >= seats
        @passenger = Passenger.create(book_params)
        @passenger.status = "Booked"
        @passenger.update(price: publish.set_price * seats)
 
        if @passenger.save
          publish.update(passengers_count: publish.passengers_count - seats)
          if publish.passengers_count == 0
            publish.update(status: "Full")
          end
          render json: @passenger, status: :created
        else
          render json: @passenger.errors, status: :unprocessable_entity
        end
      else
        render json: { error: "Insufficient seats available" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid ride" }, status: :unprocessable_entity
    end
  end

  def cancel_publish
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger && @passenger.user_id == current_user.id
      publish = @passenger.publish
      seats = @passenger.seats

      if publish
        publish.update(passengers_count: publish.passengers_count + seats)
      end

      @passenger.update(status: "Cancelled")
      publish.update(status: "")
      render json: { message: "Ride successfully cancelled" }, status: :ok
    else
      render json: { error: "Invalid passenger or unauthorized" }, status: :unprocessable_entity
    end
  end
  
  private 

  def book_params
      params.require(:passenger).permit(:publish_id,:seats).merge(user_id: current_user.id)
  end
end
