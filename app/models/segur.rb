class Segur
  include Mongoid::Document

  store_in collection: "segur"

  field :name_id
  field :name
  field :phone
  field :email
  field :link
end
