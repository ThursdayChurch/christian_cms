ActionController::Routing::Routes.draw do |map|

  map.root :controller => "articles"

  map.connect '/admin', :controller => 'sessions', :action => 'new'
  map.connect '/article/:permalink', :controller => 'articles', :action => 'show'
  map.permalink '/article/:permalink', :controller => 'articles', :action => 'show'
  
  map.register '/register', :controller => 'users', :action => 'new'
  map.signup '/signup', :controller => 'users', :action => 'new'
  
  map.resources :news
  map.resources :articles  
  map.resources :buletins
  map.resources :events
  map.resources :birthdays
  map.resources :settings
  map.resources :users
  map.resource :session

  map.with_options :controller => 'sessions' do |session|
    session.login    'login',  :action => 'new'
    session.logout   'logout', :action => 'destroy'
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  # Non existing URL, send a "301 Moved Permanently"
  map.connect '*path', :controller => "articles", :action => "moved_permanently"
end
