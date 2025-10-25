require_relative "route_constraints"

Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up", to: "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest

  root to: "users#dashboard", constraints: RouteConstraints::UserRequiredConstraint.new
  root to: "sessions#new", as: nil

  get    "login",  to: "sessions#new",       as: "login"
  delete "logout", to: "sessions#destroy",   as: "logout"
  get    "signup", to: "users#new",          as: "signup"

  resources :users, param: :secret_id do
    get "dashboard", on: :collection
    resources :films, module: :users do
      delete "destroy_intents", on: :member
    end
    resources :books, module: :users do
      delete "destroy_intents", on: :member
    end
  end

  resources :compilation_inclusions, only: [:create]
  resources :sessions, only: %i[new create destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

# == Route Map
#
#                                Prefix Verb   URI Pattern                                                                              Controller#Action
#                                  root GET    /                                                                                        users#dashboard
#                                       GET    /                                                                                        sessions#new
#                                 login GET    /login(.:format)                                                                         sessions#new
#                                logout DELETE /logout(.:format)                                                                        sessions#destroy
#                                signup GET    /signup(.:format)                                                                        users#new
#                       dashboard_users GET    /users/dashboard(.:format)                                                               users#dashboard
#             destroy_intents_user_film DELETE /users/:user_secret_id/films/:id/destroy_intents(.:format)                               users/films#destroy_intents
#                            user_films GET    /users/:user_secret_id/films(.:format)                                                   users/films#index
#                                       POST   /users/:user_secret_id/films(.:format)                                                   users/films#create
#                         new_user_film GET    /users/:user_secret_id/films/new(.:format)                                               users/films#new
#                        edit_user_film GET    /users/:user_secret_id/films/:id/edit(.:format)                                          users/films#edit
#                             user_film GET    /users/:user_secret_id/films/:id(.:format)                                               users/films#show
#                                       PATCH  /users/:user_secret_id/films/:id(.:format)                                               users/films#update
#                                       PUT    /users/:user_secret_id/films/:id(.:format)                                               users/films#update
#                                       DELETE /users/:user_secret_id/films/:id(.:format)                                               users/films#destroy
#             destroy_intents_user_book DELETE /users/:user_secret_id/books/:id/destroy_intents(.:format)                               users/books#destroy_intents
#                            user_books GET    /users/:user_secret_id/books(.:format)                                                   users/books#index
#                                       POST   /users/:user_secret_id/books(.:format)                                                   users/books#create
#                         new_user_book GET    /users/:user_secret_id/books/new(.:format)                                               users/books#new
#                        edit_user_book GET    /users/:user_secret_id/books/:id/edit(.:format)                                          users/books#edit
#                             user_book GET    /users/:user_secret_id/books/:id(.:format)                                               users/books#show
#                                       PATCH  /users/:user_secret_id/books/:id(.:format)                                               users/books#update
#                                       PUT    /users/:user_secret_id/books/:id(.:format)                                               users/books#update
#                                       DELETE /users/:user_secret_id/books/:id(.:format)                                               users/books#destroy
#                                 users GET    /users(.:format)                                                                         users#index
#                                       POST   /users(.:format)                                                                         users#create
#                              new_user GET    /users/new(.:format)                                                                     users#new
#                             edit_user GET    /users/:secret_id/edit(.:format)                                                         users#edit
#                                  user GET    /users/:secret_id(.:format)                                                              users#show
#                                       PATCH  /users/:secret_id(.:format)                                                              users#update
#                                       PUT    /users/:secret_id(.:format)                                                              users#update
#                                       DELETE /users/:secret_id(.:format)                                                              users#destroy
#                compilation_inclusions POST   /compilation_inclusions(.:format)                                                        compilation_inclusions#create
#                              sessions POST   /sessions(.:format)                                                                      sessions#create
#                           new_session GET    /sessions/new(.:format)                                                                  sessions#new
#                               session DELETE /sessions/:id(.:format)                                                                  sessions#destroy
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
