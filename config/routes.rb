Rails.application.routes.draw do
  root 'profiles#index'
  resources :profiles, param: :slug
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
