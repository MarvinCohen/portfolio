# Contact — objet de formulaire NON lié à la base de données.
#
# On utilise ActiveModel::Model plutôt qu'un modèle ActiveRecord car
# on ne veut PAS stocker les messages en base : on les envoie juste par email.
# ActiveModel nous donne quand même les validations et la compatibilité
# avec form_with (comme un vrai modèle).
class Contact
  include ActiveModel::Model

  # Les attributs accessibles du formulaire
  attr_accessor :name, :email, :message

  # --- Validations ---
  # Le nom est obligatoire
  validates :name, presence: true
  # L'email est obligatoire et doit ressembler à un email
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP,
                              message: "n'est pas une adresse valide" }
  # Le message est obligatoire et doit faire au moins 10 caractères
  validates :message, presence: true, length: { minimum: 10 }
end
