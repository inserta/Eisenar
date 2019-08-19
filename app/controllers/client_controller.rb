require 'securerandom'
require 'sendgrid-ruby'

class ClientController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new_user_from_be
    
    policies = JSON.parse(params[:policy])

    if(params[:file])
      params[:file].each_with_index do |file, index|
        if(file != "false")
          res = Cloudinary::Uploader.upload(file.tempfile.path, :folder => "pdf")
          policies[index][:file_info] = res["url"]
        end
      end
    end

    client = Client.where(dni: params[:dni].downcase).first

    if(!client)
      client = Client.create()

      salt  = ENV['SALT']
      key   = ActiveSupport::KeyGenerator.new('password').generate_key(salt, 32)
      crypt = ActiveSupport::MessageEncryptor.new(key)
      encrypted_pass = crypt.encrypt_and_sign("Eisenar2018")

      client.dni = params[:dni].downcase
      client.first_time = true
      client.password = encrypted_pass
    end

    client.name = params[:name].capitalize
    client.phone = params[:phone]
    client.email = params[:email]
    client.address = params[:address]
    client.policy = policies
    
    result_response = {}
    if(client.save)
      result_response[:code] = 200
      result_response[:text] = "success"
    else
      result_response[:code] = 400
      result_response[:text] = "error"
    end
    
    # client.close
    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: result_response
  end

  def delete_user_from_be
    deleted = Client.where(dni: params[:dni].downcase).delete

    result_response = {}
    if(deleted != 0)
      result_response[:code] = 200
      result_response[:text] = "success"
    else
      result_response[:code] = 400
      result_response[:text] = "error"
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    
    render json: result_response
  end

  def login_user_mongo
    result = {}
    client = Client.where(dni: params[:nif].downcase).first

    if(client)
      begin
        if(decrypt_password_mongo(client.password) == params[:password])
          access_token = SecureRandom.uuid.gsub(/\-/,'')
          client.token = access_token
          result_data = {}

          if(client.save)
            result[:code] = 200
            result_data[:token] = access_token
            result_data[:id] = params[:nif].downcase
            result_data[:first_time] = client.first_time
            result[:data] = result_data
          else
            result[:code] = 400
          end
        else
          result[:code] = 400
        end
      rescue Exception => e
        puts "Error messaage: #{e}"
        result[:code] = 400
      end
    else
      result[:code] = 400
      result[:message] = "wrong_user"
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: result
  end

  def decrypt_password_mongo(encrypted_data)
    salt  = ENV['SALT']
    key   = ActiveSupport::KeyGenerator.new('password').generate_key(salt, 32)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    decrypted_data = crypt.decrypt_and_verify(encrypted_data)
    
    return decrypted_data
  end

  def check_user_mongo
    client = Client.where(dni: params[:id].downcase, token: params[:token]).first

    result_response = {}
    if(client)
      result_response[:code] = 200
      result_response[:text] = "success"
      result_response[:first_time] = client.first_time
    else
      result_response[:code] = 400
      result_response[:text] = "error"
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: result_response
  end

  def recovery_password
    client = Client.where(dni: params[:number].downcase).first
    if(client)
      client.recovery_token = SecureRandom.uuid
    end

    result_response = {}
    if(client.save && create_and_send_email(client))
      result_response[:code] = 200
      result_response[:text] = "success"
    else
      result_response[:code] = 400
      result_response[:text] = "error"
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: result_response
  end

  def create_and_send_email(client)
    result = false

    begin
      @client = client
      from = SendGrid::Email.new(email: "noreply@eisenar.com")
      to = SendGrid::Email.new(email: client.email)
      subject = "Cambiar la contraseña"
      data = render_to_string(template: "home/change_password", layout: false)
      content = SendGrid::Content.new(type: 'text/html', value: data)
      mail = SendGrid::Mail.new(from, subject, to, content)
      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      response = sg.client.mail._('send').post(request_body: mail.to_json)
      
      result = true
    rescue Exception => e
      puts "Error code: #{e}"
    end
    
    return result
  end

  # Email template tester
  # def show_create_and_send_email
  #   @client = Client.where(dni: "bb").first
  #   @client.recovery_token = SecureRandom.uuid
  #   @client.save
  #   render "home/change_password", layout: false
  # end

  # change user password template
  def new_user_password
    client = Client.where(recovery_token: params[:recovery_token]).first

    if(client)
      render "home/change_password_template", layout: "application"
    else
      render "home/change_password_template_error"
    end

  end

  # change_user_password confirm
  def change_user_password
    client = Client.where(recovery_token: params[:recovery_token]).first

    result_response = {}
    if(client.email == params[:email])
      salt  = ENV['SALT']
      key   = ActiveSupport::KeyGenerator.new('password').generate_key(salt, 32)
      crypt = ActiveSupport::MessageEncryptor.new(key)
      encrypted_pass = crypt.encrypt_and_sign(params['password'])
      client.recovery_token = ""
      client.password = encrypted_pass
      
      if(client.save)
        result_response[:code] = 200
        result_response[:text] = "success"
      else
        result_response[:code] = 400
        result_response[:text] = "error"
      end
    else
      result_response[:code] = 400
      result_response[:text] = "error"
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: result_response
  end

  def change_password_first_time
    client = Client.where(dni: params[:dni].downcase).first

    result_response = {}
    if(client)
      salt  = ENV['SALT']
      key   = ActiveSupport::KeyGenerator.new('password').generate_key(salt, 32)
      crypt = ActiveSupport::MessageEncryptor.new(key)
      encrypted_pass = crypt.encrypt_and_sign(params[:password])

      client.password = encrypted_pass
      client.first_time = false

      if(client.save)
        result_response[:code] = 200
        result_response[:text] = "success"
      else
        result_response[:code] = 400
        result_response[:text] = "error"
      end
    else
      result_response[:code] = 400
      result_response[:text] = "error"
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: result_response
  end

  def data_to_datatable
    search_data = params['search']['value']
    if(params["order"])
      if(params["order"]["0"]["column"] == "0")
        sort_data = {name: (params["order"]["0"]["dir"] == "asc" ? 1 : -1)}
      elsif(params["order"]["0"]["column"] == "1")
        sort_data = {dni: (params["order"]["0"]["dir"] == "asc" ? 1 : -1)}
      else
        sort_data = { _id: -1 }
      end
    else
      sort_data = { _id: -1 }
    end
    
    skip = params["start"].to_i
    limit = params["length"].to_i
    client = Client.where(dni: /#{search_data}/).sort( sort_data ).skip(skip).limit(limit)
    to_send = {
      "recordsTotal": client.size,
      "recordsFiltered": client.size,
      "data": client.as_json
    }

    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: to_send
  end

  def import_xls
    puts "======"
    p params[:file]
    puts "======"
    ClientImport.import_xls(params[:file])
  end
end
