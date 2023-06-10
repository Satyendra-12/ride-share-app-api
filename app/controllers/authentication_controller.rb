class AuthenticationController < ApplicationController
    def phone  
        @user = User.find_by_phone_number(params[:phone_number])
        
        if @user && @user.send_passcode
          render(json: {message: 'Sent passccode'}, status: :ok)
        else
          render(json: {error: 'failed to send passcode'}, status: :unauthorized)
        end
      end

    def verify
        @user = User.find_by_phone_number(params[:phone_number])
        if @user && @user.verify_passcode(params[:passcode])
          render(json: {message:'Phone number verified!'}, status: :ok)
        else
          render(json: {error: 'Failed to verify passcode'}, status: :unauthorized)
        end
    end
      
end
