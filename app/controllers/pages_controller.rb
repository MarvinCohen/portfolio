# PagesController — gère les pages statiques publiques.
# Ici une seule action : la home (page d'accueil unique du portfolio).
class PagesController < ApplicationController
  # GET "/" → affiche la page d'accueil one-page.
  def home
    # Liste des projets affichés dans la section projets
    @projects = Project.all
    # On instancie un objet Contact vide pour alimenter le form_with
    # de la section contact (form_with a besoin d'un objet model).
    @contact = Contact.new
  end

  # GET "/sitemap.xml" → plan du site au format XML pour les moteurs de recherche.
  def sitemap
    # On charge tous les projets : chacun a une page détail à référencer.
    @projects = Project.all
    # On répond explicitement en XML (la vue sitemap.xml.erb est rendue).
    respond_to do |format|
      format.xml
    end
  end
end
