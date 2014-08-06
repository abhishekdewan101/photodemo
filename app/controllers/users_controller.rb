class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  # For all responses in this controller, return the CORS access control headers.
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.

  def cors_preflight_check
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
    headers['Access-Control-Max-Age'] = '1728000'
  end
    
    def index
        @users = User.all
        
        render :json => @users
    end
    
    def create
        @user = User.new(user_params)
        if @user.save
            json_hash = {:name => "#{@user[:username]}",:status=>"Saved"}
            render json: json_hash
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end
    
    def user_params
        params.require(:users).permit(:username,:active,:userid)
	end

    def show
        if params[:id] == "active"
            @users = User.where(active:"true")
            render json: @users
        end
        
        if params[:id] == "present"
            @users = User.where(userid:params[:userid])
            render json: @users
        end    
    end
end





