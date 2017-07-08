Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "feeds#index"

  resources :feeds do
    resources :articles, only: [:show]
  end


end
