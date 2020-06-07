# == Route Map
#
#                                Prefix Verb   URI Pattern                                                                              Controller#Action
#                                skills GET    /skills(.:format)                                                                        skills#index
#                                       POST   /skills(.:format)                                                                        skills#create
#                             new_skill GET    /skills/new(.:format)                                                                    skills#new
#                            edit_skill GET    /skills/:id/edit(.:format)                                                               skills#edit
#                                 skill GET    /skills/:id(.:format)                                                                    skills#show
#                                       PATCH  /skills/:id(.:format)                                                                    skills#update
#                                       PUT    /skills/:id(.:format)                                                                    skills#update
#                                       DELETE /skills/:id(.:format)                                                                    skills#destroy
#                                 login GET    /login(.:format)                                                                         sessions#new
#                                       POST   /login(.:format)                                                                         sessions#create
#                                logout DELETE /logout(.:format)                                                                        sessions#destroy
#                 skill_edit_admin_user GET    /admin/users/:id/skill_edit(.:format)                                                    admin/users#skill_edit
#               skill_update_admin_user POST   /admin/users/:id/skill_update(.:format)                                                  admin/users#skill_update
#     skill_proficiency_edit_admin_user GET    /admin/users/:id/skill_proficiency_edit(.:format)                                        admin/users#skill_proficiency_edit
#   skill_proficiency_update_admin_user POST   /admin/users/:id/skill_proficiency_update(.:format)                                      admin/users#skill_proficiency_update
#                           admin_users GET    /admin/users(.:format)                                                                   admin/users#index
#                                       POST   /admin/users(.:format)                                                                   admin/users#create
#                        new_admin_user GET    /admin/users/new(.:format)                                                               admin/users#new
#                       edit_admin_user GET    /admin/users/:id/edit(.:format)                                                          admin/users#edit
#                            admin_user GET    /admin/users/:id(.:format)                                                               admin/users#show
#                                       PATCH  /admin/users/:id(.:format)                                                               admin/users#update
#                                       PUT    /admin/users/:id(.:format)                                                               admin/users#update
#                                       DELETE /admin/users/:id(.:format)                                                               admin/users#destroy
#                                  root GET    /                                                                                        tasks#index
#                      confirm_new_task POST   /tasks/new/confirm(.:format)                                                             tasks#confirm_new
#                          import_tasks POST   /tasks/import(.:format)                                                                  tasks#import
#                                 tasks GET    /tasks(.:format)                                                                         tasks#index
#                                       POST   /tasks(.:format)                                                                         tasks#create
#                              new_task GET    /tasks/new(.:format)                                                                     tasks#new
#                             edit_task GET    /tasks/:id/edit(.:format)                                                                tasks#edit
#                                  task GET    /tasks/:id(.:format)                                                                     tasks#show
#                                       PATCH  /tasks/:id(.:format)                                                                     tasks#update
#                                       PUT    /tasks/:id(.:format)                                                                     tasks#update
#                                       DELETE /tasks/:id(.:format)                                                                     tasks#destroy
#         rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                  action_mailbox/ingresses/postmark/inbound_emails#create
#            rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                     action_mailbox/ingresses/relay/inbound_emails#create
#         rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                  action_mailbox/ingresses/sendgrid/inbound_emails#create
#   rails_mandrill_inbound_health_check GET    /rails/action_mailbox/mandrill/inbound_emails(.:format)                                  action_mailbox/ingresses/mandrill/inbound_emails#health_check
#         rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                  action_mailbox/ingresses/mandrill/inbound_emails#create
#          rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                              action_mailbox/ingresses/mailgun/inbound_emails#create
#        rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                 rails/conductor/action_mailbox/inbound_emails#index
#                                       POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                 rails/conductor/action_mailbox/inbound_emails#create
#     new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                             rails/conductor/action_mailbox/inbound_emails#new
#    edit_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id/edit(.:format)                        rails/conductor/action_mailbox/inbound_emails#edit
#         rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#show
#                                       PATCH  /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#update
#                                       PUT    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#update
#                                       DELETE /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#destroy
# rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                      rails/conductor/action_mailbox/reroutes#create
#                    rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#             rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#                    rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#             update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#                  rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  
  resources :skills
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  # match '/login', to: 'sessions#create', via: [:post, :patch, :put]
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    resources :users do
      get :skill_edit, on: :member
      post :skill_update, on: :member
      get :skill_proficiency_edit, on: :member
      post :skill_proficiency_update, on: :member
    end
  end

  root to: 'tasks#index'
  # get 'tasks/index'
  # get 'tasks/show'
  # get 'tasks/new'
  # get 'tasks/edit'
  resources :tasks do
    post :confirm, action: :confirm_new, on: :new
    post :import, on: :collection
    get :plan, on: :collection
    post :check_plan, on: :collection
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
