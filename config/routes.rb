RobertdouganCom::Application.routes.draw do
    devise_for :users

    namespace :admin do
    resources :posts
    end

    match 'posts/:permalink' => 'posts#show', :as => :post
    match '/feed' => 'posts#feed', :as => :feed, :defaults => { :format => 'atom' }

    # sencha examples
    match 'sencha' => 'sencha#index'
    match 'sencha/:product' => 'sencha#index'

    root :to => 'posts#index'
end
