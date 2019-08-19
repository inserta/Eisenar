class User
  include Mongoid::Document

  field :username
  field :password
end
