RobertdouganCom::Application.routes.draw do
  match 'posts/:permalink' => 'posts#show'
  root :to => 'posts#index'
end
