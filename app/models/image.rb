class Image
    include Mongoid::Document
    mount_uploader :image, ImageUploader
    field :from, type: String
    field :to,type: String
    field :uuid,type: String
    field :newvalue, type: String
end