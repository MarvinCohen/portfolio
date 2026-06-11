require "test_helper"

# Tests du ContactsController (envoi du formulaire de contact).
class ContactsControllerTest < ActionDispatch::IntegrationTest
  # Avec des données valides : un email est envoyé et on est redirigé.
  def test_create_avec_donnees_valides_envoie_un_email
    # assert_emails vérifie qu'exactement 1 email part pendant le bloc
    assert_emails 1 do
      post contacts_path, params: { contact: {
        name: "Recruteur Test",
        email: "recruteur@exemple.com",
        message: "Bonjour, votre profil nous intéresse beaucoup."
      } }
    end
    # On doit être redirigé vers la home (ancre #contact)
    assert_redirected_to root_path(anchor: "contact")
  end

  # Avec des données invalides : aucun email, on réaffiche la home avec erreurs.
  def test_create_avec_donnees_invalides_n_envoie_pas_d_email
    assert_emails 0 do
      post contacts_path, params: { contact: {
        name: "",
        email: "pas-un-email",
        message: "court"
      } }
    end
    # La page est réaffichée avec le statut "entité non traitable"
    assert_response :unprocessable_entity
  end
end
