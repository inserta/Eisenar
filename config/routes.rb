Rails.application.routes.draw do
  root "home#index"

  # Home content controller
  post "change_home_content_line" => "home_content#change_home_content_line"
  get "home_content" => "home_content#get_home_content"

  # Link controller
  post "change_link_line" => "link#change_link_line"
  get "get_links" => "link#get_links"
  post "delete_link_line" => "link#delete_link_line"

  # Contact security controller
  post "change_contact_seg" => "security#change_contact_seg"
  post "delete_contact_seg" => "security#delete_contact_seg"
  get "get_contacts_seg" => "security#get_contacts_seg"

  # Offer controller
  get "get_offer" => "offer#get_offer"
  post "change_offer_line" => "offer#change_offer_line"
  post "delete_offer_line" => "offer#delete_offer_line"

  # Other controller
  post "save_contacts" => "other#save_contacts"
  get "get_contacts" => "other#get_contacts"


  # Client controller
  # post "new_user" => "client#new_user"
  # post "login_user" => "client#login_user"
  # post "check_user" => "client#check_user"
  post "recovery_password" => "client#recovery_password"
  get "new_user_password/:recovery_token" => "client#new_user_password", as: "new_user_password"
  post "change_user_password/:recovery_token" => "client#change_user_password"
  post "new_user_from_be" => "client#new_user_from_be"
  post "delete_user_from_be" => "client#delete_user_from_be"
  post "login_user_mongo" => "client#login_user_mongo"
  post "check_user_mongo" => "client#check_user_mongo"
  post "change_password_first_time" => "client#change_password_first_time"
  post "data_to_datatable" => "client#data_to_datatable"
  
  post "matricula_by_dni" => "home#matricula_by_dni"
  post "policies_by_dni" => "home#policies_by_dni"
  post "send_question" => "home#send_question"  

  # Admin controller Login
  get "sign_in" => "home#sign_in_template"
  get "sign_out_admin" => "home#sign_out_admin"
  post "sign_in_admin" => "home#sign_in_admin"
  post "create_user_admin" => "home#create_user_admin"

  # Post Match
  # match 'new_user' => "home#handle_options", via: :options
  # match 'login_user' => "home#handle_options", via: :options
  # match 'check_user' => "home#handle_options", via: :options
  match 'recovery_password' => "home#handle_options", via: :options
  match 'new_user_from_be' => "home#handle_options", via: :options
  match 'delete_user_from_be' => "home#handle_options", via: :options
  match 'login_user_mongo' => "home#handle_options", via: :options
  match 'check_user_mongo' => "home#handle_options", via: :options
  match 'matricula_by_dni' => "home#handle_options", via: :options
  match 'policies_by_dni' => "home#handle_options", via: :options
  match 'send_question' => "home#handle_options", via: :options
  match 'change_password_first_time' => "home#handle_options", via: :options
  match 'sign_in_admin' => "home#handle_options", via: :options
  match 'create_user_admin' => "home#handle_options", via: :options


  # get 'show_create_and_send_email' => "client#show_create_and_send_email"

  post 'schedule_cron_daily' => 'scheduler#schedule_cron_daily'
  get 'schedule_daily_execute_now' => 'scheduler#schedule_daily_execute_now'
  get 'unschedule_cron_daily' => 'scheduler#unschedule_cron_daily'
  get 'check_schedule' => 'scheduler#check_schedule'
  
  post 'schedule_cron_import' => 'scheduler#schedule_cron_import'
  get 'schedule_import_execute_now' => 'scheduler#schedule_import_execute_now'
  get 'unschedule_cron_import' => 'scheduler#unschedule_cron_import'
  get 'check_schedule_import' => 'scheduler#check_schedule'

  post 'import_clients' => 'client#import_xls'
end
