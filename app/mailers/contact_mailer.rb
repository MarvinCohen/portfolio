# ContactMailer — envoie les messages du formulaire de contact vers ma boîte mail.
class ContactMailer < ApplicationMailer
  # new_message — construit et envoie l'email à partir d'un objet Contact.
  # @param contact [Contact] l'objet de formulaire validé (name, email, message)
  def new_message(contact)
    # On stocke les infos dans des variables d'instance pour la vue de l'email
    @contact = contact

    # Envoi du mail :
    # - to : ma propre adresse (je reçois le message)
    # - reply_to : l'email du visiteur → je peux répondre directement
    # - subject : objet clair pour repérer les messages du portfolio
    mail(
      to: "marvincohen95@gmail.com",
      reply_to: contact.email,
      subject: "[Portfolio] Nouveau message de #{contact.name}"
    )
  end
end
