class PublishesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_publish, only: [:show, :update, :destroy]
  
  def index 
    @passenger_rides = Passenger.where(user_id: current_user.id).pluck(:publish_id)
    @passenger_total_rides = Publish.where(id: @passenger_rides) 
    @driver_rides = Publish.where(driver_id: current_user.id)
    @rides =  @passenger_total_rides + @driver_rides    
    render json: @rides
  end
  
  # GET /rides/1
  def show
    @rides = Passenger.where(publish_id: @publish.id)
    @driver = User.find_by(id: @publish.driver_id)
    @vehicle = Vehicle.find_by(id: @publish.vehicle_id)
    passengers = []
    @rides.each do |ride|
      user = User.find_by(id: ride.user_id)
      passengers << user.first_name if user.present?
    end
    render json: {status:200,
      data: @publish,
      driver: @driver.first_name,
      cotravellers: passengers ,
      vehicle: @vehicle.vehicle_name,
      vehiclecolor: @vehicle.vehicle_color
    }
  end
  
  def sort_publish()
    order_by = params[:order_by]
    case order_by
    when "time"
      @publish = Publish.order(time: :asc)
    when "date"
      @publish = Publish.order(date: :asc)
    when "set_price"
      @publish = Publish.order(set_price: :asc)
    else
      @publish = Publish.all
    end
  
    render json: {
      publish: @publish
    }, status: :ok
  end
  
  

  def create
    @publish = Publish.new(publish_params)
  
    if current_user.vehicles.exists?(id: @publish.vehicle_id)
      if @publish.save
        render json: @publish, status: :created, location: @publish
      else
        render json: { errors: @publish.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid vehicle_id' }, status: :unprocessable_entity
    end
  end
  
  

  def search
    source_rides = Publish.near([params[:source_latitude], params[:source_longitude]], 5, units: :km,latitude: :source_latitude, longitude: :source_longitude).where(date: params[:date]).where('passengers_count> 0').where('passengers_count >= ?', params[:passengers_count].to_i).where('driver_id != ?',current_user.id).where('status != ?', "Cancelled")
    destination_rides = Publish.near([params[:destination_latitude], params[:destination_longitude]], 5, units: :km,latitude: :destination_latitude, longitude: :destination_longitude)
    @publishes = source_rides & destination_rides

    if @publishes.length >0
      render json: @publishes
    else 
      render json: "No rides found"
    end
  end

  # PATCH/PUT /publishes/1
  def update
    if @publish.update(publish_params)
      render json: @publish
    else
      render json: @publish.errors, status: :unprocessable_entity
    end
  end

  

  def destroy
    @publish.update(status:"Cancelled")
    render json: { status: :deleted }, status: :ok
  end


  private
  
  def set_publish
    @publish = Publish.find(params[:id])
  end

  def publish_params
    params.require(:publish).permit(:source, :destination, :source_longitude, :source_latitude, :destination_longitude, :destination_latitude, :passengers_count, :add_city, :date, :time, :set_price, :about_ride, :vehicle_id, :book_instantly, :mid_seat, select_route: {}).merge(driver_id: current_user.id).tap do |whitelisted|
    whitelisted[:vehicle_id] = params[:publish][:vehicle_id] if params[:publish].has_key?(:vehicle_id)
    end
  end
  
end
