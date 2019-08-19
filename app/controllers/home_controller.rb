require 'sendgrid-ruby'
# require 'securerandom'
# require 'fileutils'

# require 'savon'
# require 'fcm'

class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :require_login, only: [:index]

  def index    
    @home_content = Home.all.sort( { _id: 1 } )
    @links = Link.all.sort( { _id: 1 } )
    @contact_segs = Segur.all

    other_data = Other.all
    @other = {}
    Other.all.each do |item|
      @other[item.name] = item.data
    end

    @segur_type = SegurType.all

    @users = Client.all.sort( { _id: -1 } )
    @offer = Offer.all.sort( { _id: -1 } )

    @schedule_daily = Scheduler.where(type: "daily").first
    @schedule_import = Scheduler.where(type: "import").first
  end

  # OPTIONS handle_options
  def handle_options
    logger.debug "handle_options"
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST,OPTIONS,GET'
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type,ACCESS_TOKEN'
    head :ok, content_type: "text/html"
  end

  def matricula_by_dni
    result = {}
    client = Client.where(dni: params[:dni].downcase).first
    other = Other.where(name: "auto_type").first

    matriculas = []
    if(client)

      matricula = {}
      client.policy.each do |policy|
        if(policy[:active] && policy[:type] == "auto")
          matricula[:company] = policy[:company]
          matricula[:matricula] = policy[:matricula]
          other.data.each do |type|
            if(policy[:auto_type] == type["name_id"])
              matricula[:auto_type] = type["name"]
            end
          end

          matriculas.push(matricula)
          matricula = {}
        end
      end

      result_data = {}

      result[:code] = 200
      result_data[:matriculas] = matriculas
      result[:data] = result_data
    else
      result[:code] = 400
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: result
  end

  def policies_by_dni
    client = Client.where(dni: params[:dni].downcase).first

    result = {}
    policies = []
    if(client)
      client.policy.each do |policy|
        if(policy[:active])
          policies.push(policy)
        end
      end

      result_data = {}

      result[:code] = 200
      result_data[:policies] = policies
      result[:data] = result_data
    else
      result[:code] = 400
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: result
  end

  def send_question
    other = Other.where(name: "question_mail").first

    @dni = params[:dni]
    @message = params[:message]

    result_response = {}
    if(send_question_mail(other.data))
      result_response[:code] = 200
      result_response[:text] = "success"
    else
      result_response[:code] = 400
      result_response[:text] = "error"
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: result_response
  end

  def send_question_mail(questions_email)
    result = false
    begin
      from = SendGrid::Email.new(email: "question@eisenar.com")
      to = SendGrid::Email.new(email: questions_email)
      subject = "Contacto del usuario"
      data = render_to_string(template: "home/mail/from_question", layout: false)
      content = SendGrid::Content.new(type: 'text/html', value: data)
      mail = SendGrid::Mail.new(from, subject, to, content)
      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      response = sg.client.mail._('send').post(request_body: mail.to_json)

      result = true
    rescue Exception => e
      puts "Error message: #{e}"
    end

    return result
  end

  def hash_password(password)
    BCrypt::Password.create(password).to_s
  end
  
  def test_password(password, hash)
    BCrypt::Password.new(hash) == password
  end

  def sign_in_template
    if(session[:user_id_token])
      begin
        User.find(session[:user_id_token])
        redirect_to "/"
      rescue Mongoid::Errors::DocumentNotFound
        puts "User nao existe"
        render "home/sign_in", layout: "application"
      end
    else
      render "home/sign_in", layout: "application"
    end
  end

  def create_user_admin
    user = User.create()
    user.username = params[:username].downcase
    user.password = hash_password(params[:password])

    user.save
  end

  def sign_in_admin
    user = User.where(username: params[:username].downcase).first

    result_response = {}
    if(user && test_password(params[:password], user.password))
      session.clear
      session[:user_id_token] = user.id.as_json
      result_response[:code] = 200
      result_response[:text] = "success"
    else
      result_response[:code] = 400
      result_response[:text] = "error"
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: result_response
  end

  def sign_out_admin
    session.clear
    redirect_to '/sign_in'
  end
  
  private

  def require_login
    if(session[:user_id_token])
      begin
        User.find(session[:user_id_token])
      rescue Mongoid::Errors::DocumentNotFound
        puts "User nao existe"
        redirect_to "/sign_in"
      end
    else
      redirect_to "/sign_in"
    end
  end
end
