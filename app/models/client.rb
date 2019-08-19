class Client
  include Mongoid::Document

  store_in collection: "client"

  field :name
  field :dni
  field :phone
  field :email
  field :address
  field :first_time
  field :token
  field :recovery_token
  field :password
  field :policy

  def self.import_xls(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)

    puts "*****"
    (2..spreadsheet.last_row).each do |i|
      puts "---"
      puts spreadsheet.row(i)[0]
      puts spreadsheet.row(i)[1]
      puts spreadsheet.row(i)[2]
      puts spreadsheet.row(i)[3]
      puts spreadsheet.row(i)[4]
      puts spreadsheet.row(i)[5]
      puts spreadsheet.row(i)[6]
      puts spreadsheet.row(i)[7]
      puts spreadsheet.row(i)[8]
      puts "---"
    end
    puts "*****"
  end
end
