require "test_helper"

# Tests du PagesController (page d'accueil).
class PagesControllerTest < ActionDispatch::IntegrationTest
  # Vérifie que la home répond bien (statut 200) et affiche le contenu attendu.
  def test_home_repond_avec_succes
    get root_path
    assert_response :success
  end

  # Vérifie que les 3 projets sont présents sur la page.
  def test_home_affiche_les_projets
    get root_path
    assert_select "h3.project-card__name", text: /Noctilio/
    assert_select "h3.project-card__name", text: /Teams Up/
    assert_select "h3.project-card__name", text: /Biche/
  end

  # Vérifie que le formulaire de contact est présent sur la home.
  def test_home_affiche_le_formulaire_contact
    get root_path
    assert_select "form.contact-form"
  end

  # Vérifie que le sitemap XML répond et liste la home + les pages projets.
  def test_sitemap_xml_repond_et_liste_les_pages
    get sitemap_path
    # Réponse OK
    assert_response :success
    # Le type de contenu doit bien être du XML
    assert_equal "application/xml", response.media_type
    # On retrouve l'URL de la home et celle d'au moins un projet
    assert_match root_url, response.body
    assert_match project_url("noctilio"), response.body
  end
end
