class OtherController < ApplicationController
  skip_before_action :verify_authenticity_token

  def save_contacts
    other = Other.all

    other.each do |item|
      if(item.name == "contact_sevilla")
        item.data = params[:contact_map_sevilla].split("\n")
      elsif(item.name == "contact_madrid")
        item.data = params[:contact_map_madrid].split("\n")
      elsif(item.name == "contact_interes")
        item.data = params[:contact_map_interes].split("\n")
      elsif(item.name == "question_mail")
        item.data = params[:questions_email]
      elsif(item.name == "offer_contact")
        item.data = params[:offer_contact]
      end
      item.save
    end

    result_response = {}
    result_response[:code] = 200
    result_response[:text] = "success"

    response.headers['Access-Control-Allow-Origin'] = '*'
    
    render json: result_response
  end

  def get_contacts
    other = Other.all

    to_send = {}
    other.each do |item|
      # if(item.name == "contact_sevilla" || item.name == "contact_madrid")
      #   data = item.data.join("\n")
      # else
      #   data = item.data
      # end
      to_send[item.name] = item.data
    end
    
    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: to_send
  end
end
