Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "test#index"
  end
end
