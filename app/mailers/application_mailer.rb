class ApplicationMailer < ActionMailer::Base
  # Expéditeur par défaut de tous les emails de l'app.
  # On utilise l'adresse "onboarding@resend.dev" : sans domaine vérifié,
  # c'est la seule adresse d'envoi autorisée par Resend (offre gratuite).
  # Le reply_to (défini dans ContactMailer) reste l'email du visiteur, donc
  # je peux quand même répondre directement à la personne qui m'écrit.
  default from: "onboarding@resend.dev"
  layout "mailer"
end
