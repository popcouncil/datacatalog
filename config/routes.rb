ActionController::Routing::Routes.draw do |map|
  map.resources :data_records, :as => "data", :except => [:destroy, :new] do |data_record|
    data_record.resource :favorite, :only => [:create, :destroy]
    data_record.resource :rating, :only => [:update]
    data_record.resources :notes, :only => [:index, :create]
    data_record.resources :comments, :only => [:create] do |comments|
      comments.resources :votes, :only => [:create]
    end
    data_record.resource :wiki, :as => "docs", :only => [:show, :edit, :update]
  end

  map.new_data_record '/data-new', :controller => 'data_records', :action => 'new'
  map.tour '/tour', :controller => 'main', :action => 'tour'
  map.tools '/tools', :controller => 'main', :action => 'tools'
  map.resources :contest, :except => [:index, :destroy, :edit], :collection => [:admin], :member => [:submission]

  map.resources :organizations, :as => :org, :only => [:show]

  map.namespace :admin do |admin|
    admin.resources :organizations, :only => [:index, :show, :new, :create, :update]
    admin.resources :data_records, :only => [:index]
    admin.resources :users, :only => [:index, :show, :new, :create, :update]
    admin.resources :contact_submissions, :only => [:index, :show, :update]
  end

  map.resources :users, :only => [:new, :create]
  map.resource :alerts, :only => [:update, :destroy]
  map.resource :profile, :controller => "users", :only => [:edit, :update]
  map.resource :user_session

  map.resource :static

  map.dashboard '/dashboard', :controller => 'main', :action => :dashboard
  map.root                                                        :controller => "main",            :action => "index"
  map.about              "about",                                 :controller => "main",            :action => "about"
  map.blog               "blog",                                  :controller => "main",            :action => "blog"
  map.confirm            "confirm/:token",                        :controller => "users",           :action => "confirm"
  map.contact            "contact",                               :controller => "contact",         :action => "index"
  map.contact_submission "contact/submit",                        :controller => "contact",         :action => "submit"
  map.dashboard          "dashboard",                             :controller => "main",            :action => "dashboard"
  map.send_reset         "forgot/sent",                           :controller => "password_resets", :action => "create"
  map.forgot             "forgot",                                :controller => "password_resets", :action => "new"
  map.perform_reset      "reset/attempt",                         :controller => "password_resets", :action => "update"
  map.reset              "reset/:token",                          :controller => "password_resets", :action => "edit"
  map.search             "search",                                :controller => "search",          :action => "index"
  map.signin             "signin",                                :controller => "user_sessions",   :action => "new"
  map.signout            "signout",                               :controller => "user_sessions",   :action => "destroy"
  map.signup             "signup",                                :controller => "users",           :action => "new"
  map.source             "data/:slug",                            :controller => "data",            :action => "show"
  map.source_create_doc  "data/:slug/docs/create",                :controller => "data",            :action => "create_doc"
  map.source_docs        "data/:slug/docs",                       :controller => "data",            :action => "docs"
  map.source_edit_docs   "data/:slug/docs/edit",                  :controller => "data",            :action => "edit_docs"
  map.source_show_doc    "data/:slug/docs/:id",                   :controller => "data",            :action => "show_doc"
  map.source_update_doc  "data/:slug/docs/:id/update",            :controller => "data",            :action => "update_doc"
  map.source_usages      "data/:slug/usages",                     :controller => "data",            :action => "usages"
  map.wordpress_callback "wordpress/callback", :controller => 'wordpress', :action => 'callback'

  map.connect ":controller/:action/:id"
  map.connect ":controller/:action/:id.:format"

end
