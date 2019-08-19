class Home
  include Mongoid::Document
  store_in collection: "home"

  field :name_id
  field :display_name
  field :active
end
