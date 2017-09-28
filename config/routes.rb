Rails.application.routes.draw do
  resources :porters
  resources :sprinkle_agents
  resources :sprinkles
  resources :valves
  resources :minute_hands
  mount Hyperloop::Engine => '/hyperloop'
  # For details on the DSL available within this file, see http://guides.rubyonrails.orgcd/routing.html
  root 'hyperloop#app'
end
