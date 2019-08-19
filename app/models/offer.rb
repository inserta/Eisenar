class Offer
  include Mongoid::Document

  store_in collection: "offer"

  field :name
  field :description
  field :visible
  field :link
  field :type
  field :file_info
end
