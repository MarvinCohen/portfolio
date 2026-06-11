# ProjectsController, affiche la page détail (étude de cas) d'un projet.
class ProjectsController < ApplicationController
  # GET "/projets/:slug" → affiche le détail d'un projet.
  def show
    # On retrouve le projet par son slug d'URL
    @project = Project.find(params[:slug])
    # Si aucun projet ne correspond, on renvoie une vraie erreur 404
    # (page introuvable) plutôt qu'une page vide.
    # Le titre de page dédié (pour le référencement et l'onglet du navigateur)
    # est défini dans la vue show.html.erb via content_for, car content_for
    # est un helper de vue et n'existe pas dans un controller.
    raise ActiveRecord::RecordNotFound if @project.nil?
  end
end
