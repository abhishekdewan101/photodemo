class User
    include Mongoid::Document
    field :username, type: String
    field :active, type: String    
    field :userid, type:String
end