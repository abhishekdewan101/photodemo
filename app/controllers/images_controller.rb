require 'pp'

class ImagesController < ApplicationController
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
        @images = Image.all
        
        render :json => @images
    end
    
    def create
        @image = Image.new(user_params)
        if @image.save
            json_hash = {:name => "#{@image[:uuid]}",:status=>"Saved"}
            render json: json_hash
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def show
        if params[:id] == "delete"
            @image = Image.where(uuid:params[:uuid])
            @image.delete
        end
        
        if params[:id] == "shareto"
            @image = Image.where(to:params[:to])
            render json: @image
        end
        
        if params[:id] == "sharefrom"
            @image = Image.where(from:params[:from])
            render json: @image
        end
        
        if params[:id] == "new"
            @image = Image.where(to:params[:to],newvalue:"yes")
            render json: @image
        end
        
        if params[:id] == "setnew"
            @image = Image.where(uuid:params[:uuid]).first
            #pp @image
            @image.newvalue = "no"
            @image.save
        end
    end
    
    def user_params
        params.require(:images).permit(:image,:from,:to,:uuid,:newvalue)
	end
end


