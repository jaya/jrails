Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  root 'home#index'
  get 'redirect', to: 'home#redirect'
  get 'text', to: 'home#text'
  get 'json', to: 'home#json'
  get 'jaya_header', to: 'home#jaya_header'
  get 'cookie', to: 'home#cookie'
  get 'flash', to: 'home#flashman'
  get 'not_modified', to: 'home#not_modified'
  get 'rescue_from', to: 'home#rescue_from_action'
end
