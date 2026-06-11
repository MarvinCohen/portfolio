require "test_helper"

# Tests du ProjectsController (page détail d'un projet, étude de cas).
class ProjectsControllerTest < ActionDispatch::IntegrationTest
  # Un slug valide affiche la page détail avec le nom du projet.
  def test_show_avec_slug_valide_affiche_le_projet
    get project_path("noctilio")
    # La page répond avec succès
    assert_response :success
    # Le titre de la page détail contient le nom du projet
    assert_select "h1.project-detail__title", text: /Noctilio/
  end

  # Le projet privé (Biche) affiche le lien "projet privé" au lieu du code.
  def test_show_projet_prive_affiche_le_lien_prive
    get project_path("biche")
    assert_response :success
    # Pour un projet privé, on propose un lien vers le contact (bouton ghost)
    assert_select "a.btn--ghost"
  end

  # Un slug inexistant renvoie une vraie erreur 404 (page introuvable).
  def test_show_avec_slug_inconnu_renvoie_404
    get project_path("ce-projet-n-existe-pas")
    assert_response :not_found
  end
end
