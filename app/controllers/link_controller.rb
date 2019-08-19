class LinkController < ApplicationController
  skip_before_action :verify_authenticity_token

  def change_link_line
    begin
      link = Link.find(params[:line_id])
    rescue Mongoid::Errors::DocumentNotFound
      link = Link.create()
    end

    link.name = params[:name]
    link.url = params[:url]
    
    result_response = {}
    if(link.save)
      result_response[:code] = 200
      result_response[:id] = link._id.as_json
      result_response[:text] = "success"
    else
      result_response[:code] = 400
      result_response[:id] = params[:line_id]
      result_response[:text] = "error"
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    
    render json: result_response
  end  

  def delete_link_line
    deleted =  Link.where(id: params[:line_id]).delete

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

  def get_links
    links = Link.all.sort( { _id: -1 } )

    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: links
  end
end
