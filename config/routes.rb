Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Page d'accueil unique du portfolio (one-page avec ancres)
  root "pages#home"

  # Plan du site (sitemap) au format XML, généré dynamiquement.
  # Aide Google à découvrir la home et toutes les pages détail projets.
  get "sitemap.xml", to: "pages#sitemap", defaults: { format: "xml" }, as: :sitemap

  # Page détail d'un projet (étude de cas), ex: /projets/noctilio
  get "projets/:slug", to: "projects#show", as: :project

  # Formulaire de contact : seule l'action create est nécessaire
  # (le formulaire lui-même est affiché dans la section contact de la home)
  resources :contacts, only: [:create]
end
