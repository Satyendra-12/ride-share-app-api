# app/controllers/chats_controller.rb
class ChatsController < ApplicationController
    before_action :authenticate_user!
  
    def create
      @passenger = Passenger.find(chat_params[:passenger_id])
      @chat = @passenger.chats.build(content: chat_params[:content])
      @chat.user = current_user
      if @chat.save
        render json: @chat, status: :created
      else
        render json: { errors: @chat.errors }, status: :unprocessable_entity
      end
    end
  
    private
  
    def chat_params
      params.require(:chat).permit(:passenger_id, :content)
    end
  end
  