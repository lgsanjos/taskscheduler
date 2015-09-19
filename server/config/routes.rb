Rails.application.routes.draw do


  # consumed by cli agent
  get 'tasks/data/:token' => 'tasks#task'

  post 'execution/start' => 'task_execution#start_execution'
  post 'execution/failed' => 'task_execution#failed_execution'
  post 'execution/success' => 'task_execution#success_execution'

  # consumed by website

  resources :tasks
  get 'task_execution/index'

  root 'about#index'
end
