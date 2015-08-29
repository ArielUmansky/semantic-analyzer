Rails.application.routes.draw do

  get "analyzer" => "analyzer#perform"

end
