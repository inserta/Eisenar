class SecurityController < ApplicationController
  skip_before_action :verify_authenticity_token

  def change_contact_seg
    begin
      cont_seg = Segur.find(params[:line_id])
    rescue Mongoid::Errors::DocumentNotFound
      cont_seg = Segur.create()
    end

    if(params[:file] != "empty")
      res = Cloudinary::Uploader.upload(params[:file].tempfile.path, :folder => "image")
      cont_seg.link = res["url"]
    end
    
    cont_seg.name = params[:name]
    cont_seg.name_id = params[:name].downcase
    cont_seg.phone = params[:phone]
    cont_seg.email = params[:email]

    result_response = {}
    if(cont_seg.save)
      result_response[:code] = 200
      result_response[:text] = "success"
    else
      result_response[:code] = 400
      result_response[:text] = "error"
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    
    render json: result_response
  end

  def get_contacts_seg
    contact_seg = Segur.all
    
    to_send = {}
    
    contact_seg.each do |line|
      to_send[line.name_id] = {
        name: line.name,
        phone: line.phone,
        email: line.email,
        link: line.link
      }
    end
    
    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: to_send
  end

  def delete_contact_seg
    deleted =  Segur.where(id: params[:line_id]).delete

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
end
