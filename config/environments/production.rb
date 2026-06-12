require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Railway place l'app derrière un proxy qui gère le HTTPS (SSL).
  # assume_ssl indique à Rails que la connexion d'origine est sécurisée.
  config.assume_ssl = true

  # On force tout le trafic en HTTPS (redirection http -> https, cookies
  # sécurisés et en-tête HSTS), pour la sécurité et le référencement.
  config.force_ssl = true

  # On exclut le point de contrôle de santé /up de la redirection HTTPS,
  # car Railway l'appelle en interne en HTTP pour vérifier que l'app tourne.
  config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)

  # Change to "debug" to log everything (including potentially personally-identifiable information!).
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/up"

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Cache durable stocké en base (Solid Cache). La base "cache" pointe vers
  # la même base Railway que le reste (voir config/database.yml).
  config.cache_store = :solid_cache_store

  # File d'attente des jobs en base (Solid Queue). En pratique l'email de
  # contact part en synchrone (deliver_now), donc aucun worker n'est requis ;
  # cette config reste néanmoins celle attendue par Rails 8.
  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = { database: { writing: :queue } }

  # On veut être prévenu si un email n'arrive pas à partir (formulaire de contact).
  config.action_mailer.raise_delivery_errors = true

  # Méthode d'envoi : Resend, via son API HTTPS (port 443). On n'utilise plus
  # SMTP car Railway bloque les ports SMTP sortants (25/465/587) sur ses plans
  # Trial/Hobby. La clé API est configurée dans config/initializers/resend.rb.
  config.action_mailer.delivery_method = :resend

  # Hôte utilisé pour construire les liens dans les emails et les URL absolues.
  # APP_HOST est défini dans les variables d'environnement Railway
  # (ex : portfolio-marvin.up.railway.app, sans le https://).
  config.action_mailer.default_url_options = { host: ENV.fetch("APP_HOST", "localhost"), protocol: "https" }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [ :id ]

  # Protection contre les attaques sur l'en-tête Host (DNS rebinding) :
  # seules les requêtes vers nos domaines autorisés sont acceptées.
  # On autorise tous les sous-domaines Railway (*.up.railway.app) ainsi que
  # le domaine personnalisé éventuel, fourni via la variable APP_HOST.
  config.hosts << /.*\.up\.railway\.app/
  config.hosts << ENV["APP_HOST"] if ENV["APP_HOST"].present?

  # On exclut le point de contrôle de santé /up de cette protection,
  # car Railway l'appelle en interne avec un en-tête Host différent.
  config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
