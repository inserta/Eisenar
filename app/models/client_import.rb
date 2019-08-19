class ClientImport
  include Mongoid::Document

  store_in collection: "client_import"

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
    salt  = ENV['SALT']
    key   = ActiveSupport::KeyGenerator.new('password').generate_key(salt, 32)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    encrypted_pass = crypt.encrypt_and_sign("Eisenar2018")

    spreadsheet = Roo::Spreadsheet.open(file.path)

    records = []
    records_connection = {}
    puts "*****"
    (2..spreadsheet.last_row).each_with_index do |i, index|
      if(spreadsheet.row(i)[8])
        record = {}
        record[:address] = ""
        record[:dni] = spreadsheet.row(i)[8].downcase
        record[:email] = ""
        record[:first_time] = true
        record[:name] = spreadsheet.row(i)[8]
        record[:password] = encrypted_pass
        record[:phone] = ""
        
        if(!records_connection[spreadsheet.row(i)[8]])
          records_connection[spreadsheet.row(i)[8]] = index
          record[:policy] = []
          policy_detail = {}
          policy_detail[:company] = spreadsheet.row(i)[0]
          policy_detail[:company_text] = spreadsheet.row(i)[0]
          policy_detail[:type] = spreadsheet.row(i)[3]
          policy_detail[:type_text] = spreadsheet.row(i)[3]
          policy_detail[:auto_type] = ""
          policy_detail[:auto_type_text] = ""
          policy_detail[:matricula] = spreadsheet.row(i)[4]
          policy_detail[:active] = spreadsheet.row(i)[2] = "V" ? true : false
          policy_detail[:file_info] = ""

          record[:policy].push(policy_detail)
        else
          policy_detail = {}
          policy_detail[:company] = spreadsheet.row(i)[0]
          policy_detail[:company_text] = spreadsheet.row(i)[0]
          policy_detail[:type] = spreadsheet.row(i)[3]
          policy_detail[:type_text] = spreadsheet.row(i)[3]
          policy_detail[:auto_type] = ""
          policy_detail[:auto_type_text] = ""
          policy_detail[:matricula] = spreadsheet.row(i)[4]
          policy_detail[:active] = spreadsheet.row(i)[2] = "V" ? true : false
          policy_detail[:file_info] = ""

          records[records_connection[spreadsheet.row(i)[8]]][:policy].push(policy_detail)
        end
        records.push(record)
      end
    end
    puts "*****"

    puts "---------- RECORDS ------------"
    p records
    puts "---------- RECORDS ------------"

    puts "========"
    records.each_with_index do |record, index|
      puts "--- Client: #{index} ---"

      client = self.where(dni: record[:dni].downcase).first

      if(!client)
        client = self.create()
        client.dni = record[:dni]
        client.first_time = record[:first_time]
        client.password = record[:password]
      end

      client.name = record[:name]
      client.phone = record[:phone]
      client.email = record[:email]
      client.address = record[:address]
      client.policy = record[:policy]

      client.save
    end
    puts "========"
    
  end
end
