RobertdouganCom::Application.routes.draw do
  match 'posts/:permalink' => 'posts#show', :as => :post
  match '/feed' => 'posts#feed', :as => :feed, :defaults => { :format => 'atom' }

  root :to => 'posts#index'
end
