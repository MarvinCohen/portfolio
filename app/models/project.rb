# Project, objet simple (PORO) NON lié à la base de données.
#
# On stocke ici les données structurelles de chaque projet (identifiant,
# nom, technologies, liens). Les textes traduisibles (badge, description,
# rôle, etc.) sont lus dans les fichiers de langue via I18n, pour rester
# bilingues. Cela évite une table en base pour des données qui ne changent pas.
class Project
  include ActiveModel::Model

  # slug   : identifiant pour l'URL (/projets/noctilio)
  # name   : nom affiché (le point ".​" stylé est ajouté dans la vue)
  # stack  : liste des technologies (chips)
  # site_url / code_url : liens externes (nil si projet privé)
  # private_project : true pour un projet client sans lien public
  attr_accessor :slug, :name, :stack, :site_url, :code_url, :private_project

  # Liste de tous les projets, dans l'ordre d'affichage.
  ALL = [
    new(
      slug: "noctilio",
      name: "Noctilio",
      stack: ["Rails 8", "OpenAI GPT-4o", "Solid Queue", "Active Storage", "PostgreSQL", "Railway"],
      site_url: "https://www.noctilio-app.fr",
      code_url: "https://github.com/MarvinCohen/noctilio"
    ),
    new(
      slug: "teams-up",
      name: "Teams Up",
      stack: ["Rails 8", "ActionCable", "Hotwire", "Mapbox", "Devise", "PWA"],
      site_url: "https://www.teams-up-sport.fr",
      code_url: "https://github.com/WilliamLaime/Teams-up"
    ),
    new(
      slug: "biche",
      name: "Biche",
      stack: ["Rails", "Stimulus", "SCSS", "Stripe", "PostgreSQL", "Mobile-first"],
      private_project: true
    )
  ].freeze

  # Retourne tous les projets
  def self.all
    ALL
  end

  # Retrouve un projet par son slug (utilisé par la page détail).
  # Renvoie nil si aucun projet ne correspond.
  def self.find(slug)
    ALL.find { |project| project.slug == slug }
  end

  # Clé i18n du projet : on remplace les tirets du slug par des underscores
  # (teams-up -> teams_up) pour correspondre aux clés YAML.
  def i18n_key
    slug.tr("-", "_")
  end

  # --- Raccourcis vers les textes traduits (config/locales/*.yml) ---
  def badge   = I18n.t("projects.#{i18n_key}.badge")
  def tagline = I18n.t("projects.#{i18n_key}.tagline")
  def desc    = I18n.t("projects.#{i18n_key}.desc")
  def role    = I18n.t("projects.#{i18n_key}.role")
  def context = I18n.t("projects.#{i18n_key}.context")
  def features = I18n.t("projects.#{i18n_key}.features")
end
