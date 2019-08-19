class OfferController < ApplicationController
  skip_before_action :verify_authenticity_token

  def change_offer_line

    begin
      offer = Offer.find(params[:line_id])
    rescue Mongoid::Errors::DocumentNotFound
      offer = Offer.create()
    end

    if(params[:file] != nil)
      if(params[:file].content_type == "application/pdf")
        folder = "pdf"
      else
        folder = "image"
      end

      offer.type = params[:file].content_type
      res = Cloudinary::Uploader.upload(params[:file].tempfile.path, :folder => folder)

      offer.file_info = res
    end

    offer.name = params[:name]
    offer.description = params[:description]
    offer.visible = (params[:visible] == "true" ? true : false)
  
    result_response = {}
    if(offer.save)
      result_response[:code] = 200
      result_response[:text] = "success"
    else
      result_response[:code] = 400
      result_response[:text] = "error"
    end
    result_response[:id] = offer.id.as_json

    response.headers['Access-Control-Allow-Origin'] = '*'
    
    render json: result_response
  end

  def delete_offer_line
    deleted =  Offer.where(id: params[:line_id]).delete

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

  def get_offer
    offer = Offer.all.sort( { _id: -1 } )

    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: offer
  end
end
