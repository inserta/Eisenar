class SegurType
  include Mongoid::Document
  store_in collection: "segur_type"
  
  field :name
  field :sub_type
  field :extra_field
end
