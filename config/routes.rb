Rails.application.routes.draw do

  post "analyzer" => "analyzer#perform"

end
