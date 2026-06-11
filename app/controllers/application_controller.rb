class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Définit la langue à chaque requête (avant l'action du controller).
  before_action :set_locale

  private

  # set_locale choisit la langue selon cet ordre de priorité :
  #   1. le paramètre d'URL ?locale=en (clic sur le sélecteur de langue)
  #   2. la langue mémorisée en session (choix précédent du visiteur)
  #   3. la langue par défaut de l'app (français)
  # On mémorise ensuite le choix en session pour les pages suivantes.
  def set_locale
    requested = params[:locale] || session[:locale]
    # On ne garde la langue demandée que si elle fait partie des langues autorisées
    I18n.locale = if I18n.available_locales.map(&:to_s).include?(requested.to_s)
                    requested
                  else
                    I18n.default_locale
                  end
    session[:locale] = I18n.locale
  end

  # default_url_options : ajoute automatiquement la langue courante à toutes
  # les URLs générées par les helpers (link_to, etc.) tant qu'on n'est pas
  # en français (la langue par défaut n'a pas besoin d'apparaître dans l'URL).
  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end
end
