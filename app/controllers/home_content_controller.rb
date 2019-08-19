class HomeContentController < ApplicationController
  skip_before_action :verify_authenticity_token

  def change_home_content_line
    item = Home.find(params[:line_id])
    item.display_name = params[:display_name]
    item.active = params[:active] == "true" ? true : false
    
    result_response = {}
    if(item.save)
      result_response[:code] = 200
      result_response[:text] = "success"
    else
      result_response[:code] = 400
      result_response[:text] = "error"
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    
    render json: result_response
  end

  def get_home_content
    home_content = Home.all
    
    to_send = {}
    
    home_content.each do |line|
      to_send[line.name_id] = {
        display_name: line.display_name,
        active: line.active
      }
    end
    
    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: to_send
  end
end
