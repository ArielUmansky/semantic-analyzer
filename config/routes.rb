Rails.application.routes.draw do

  JSON_MIME_TYPE = "application/json"

  post "analyzer" => "analyzer#perform",
       :required_content_type => JSON_MIME_TYPE,
       :required_accept_type => JSON_MIME_TYPE

  get "info" => "analyzer#status_info"

end
