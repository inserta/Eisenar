require 'rufus-scheduler'
require 'schedule/daily'

scheduler = Rufus::Scheduler.singleton

schedule_daily = Scheduler.where(type: "daily").first

Rails.configuration.daily_id = scheduler.cron schedule_daily[:cron_time] do
  DailyScheduler.run_daily_tasks
end

schedule_import = Scheduler.where(type: "import").first

Rails.configuration.import_id = scheduler.cron schedule_import[:cron_time] do
  DailyScheduler.run_import_tasks
end