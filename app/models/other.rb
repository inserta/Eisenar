class Other
  include Mongoid::Document
  store_in collection: "other"

  field :name, type: String
  field :data

  def getAll()
    result = {}
    Other.all.each do |item|
      result[item.name] = item.data
    end

    result
  end
end
