class Scheduler
  include Mongoid::Document

  field :type
  field :cron_time
  field :original_hour
  field :active
end
