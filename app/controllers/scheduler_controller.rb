require 'rufus-scheduler'
require 'schedule/daily'

class SchedulerController < ApplicationController
  skip_before_action :verify_authenticity_token

  ### DAILY
  def schedule_cron_daily
    cron_time = parse_cron(params[:hour], params[:minute])
    
    schedule = Scheduler.where(type: "daily").first
    schedule.cron_time = cron_time
    schedule.active = params[:active] == "true" ? true : false
    schedule.original_hour = params[:hour]

    result_response = {}
    if(schedule.save)
      begin
        scheduler = Rufus::Scheduler.singleton
        
        if(Rufus::Scheduler.singleton.job(Rails.configuration.daily_id))
          unschedule_cron_daily
        end

        if(schedule.active)
          Rails.configuration.daily_id = scheduler.cron cron_time do
            DailyScheduler.run_daily_tasks
          end
        end

        result_response[:code] = 200
        result_response[:text] = "success"
      rescue Exception => e
        puts "***"
        p e.message
        p e.backtrace.join("\n")
        puts "Error messagem: #{e}"
        puts "***"
        result_response[:code] = 400
        result_response[:text] = "success"
      end
    else
      result_response[:code] = 400
      result_response[:text] = "success"
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    
    render json: result_response
  end

  def schedule_daily_execute_now
    result_response = {}
    begin
      DailyScheduler.run_daily_tasks
      result_response[:code] = 200
      result_response[:text] = "success"
    rescue Exception => e
      puts "Error messagem: #{e}"
      result_response[:code] = 400
      result_response[:text] = "success"
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    
    render json: result_response
  end

  def unschedule_cron_daily
    if(Rufus::Scheduler.singleton.job(Rails.configuration.daily_id))
      Rufus::Scheduler.singleton.job(Rails.configuration.daily_id).unschedule
    end
  end

  def check_schedule
    puts "===="
    if(Rufus::Scheduler.singleton.job(Rails.configuration.daily_id) && Rufus::Scheduler.singleton.job(Rails.configuration.daily_id).scheduled?)
      p Rufus::Scheduler.singleton.job(Rails.configuration.daily_id)
      puts "Runnig"
    else
      puts "Stoped"
    end
    puts "===="
  end

  ### IMPORT
  def schedule_cron_import
    cron_time = parse_cron(params[:hour], params[:minute])
    
    schedule = Scheduler.where(type: "import").first
    schedule.cron_time = cron_time
    schedule.active = params[:active] == "true" ? true : false
    schedule.original_hour = params[:hour]

    result_response = {}
    if(schedule.save)
      begin
        scheduler = Rufus::Scheduler.singleton
        
        if(Rufus::Scheduler.singleton.job(Rails.configuration.import_id))
          unschedule_cron_import
        end

        if(schedule.active)
          Rails.configuration.import_id = scheduler.cron cron_time do
            DailyScheduler.run_import_tasks
          end
        end

        result_response[:code] = 200
        result_response[:text] = "success"
      rescue Exception => e
        puts "Error messagem: #{e}"
        result_response[:code] = 400
        result_response[:text] = "success"
      end
    else
      result_response[:code] = 400
      result_response[:text] = "success"
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    
    render json: result_response
  end

  def schedule_import_execute_now
    result_response = {}
    begin
      DailyScheduler.run_import_tasks
      result_response[:code] = 200
      result_response[:text] = "success"
    rescue Exception => e
      puts "Error messagem: #{e}"
      result_response[:code] = 400
      result_response[:text] = "success"
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    
    render json: result_response
  end

  def unschedule_cron_import
    if(Rufus::Scheduler.singleton.job(Rails.configuration.import_id))
      Rufus::Scheduler.singleton.job(Rails.configuration.import_id).unschedule
    end
  end

  def check_schedule_import
    puts "===="
    if(Rufus::Scheduler.singleton.job(Rails.configuration.import_id) && Rufus::Scheduler.singleton.job(Rails.configuration.import_id).scheduled?)
      p Rufus::Scheduler.singleton.job(Rails.configuration.import_id)
      puts "Runnig"
    else
      puts "Stoped"
    end
    puts "===="
  end

  def parse_cron(hour, minute)
    if(hour == "1")
      hour = "25"
    elsif(hour == "0")
      hour = "24"
    end
    hour_to_parse = (hour.to_i - 2).to_s
    return "#{minute} #{hour_to_parse} * * *"
  end
end
