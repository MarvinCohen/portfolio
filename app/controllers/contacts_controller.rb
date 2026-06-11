# ContactsController — reçoit l'envoi du formulaire de contact.
class ContactsController < ApplicationController
  # POST "/contacts" → traite l'envoi du message.
  def create
    # On construit l'objet Contact à partir des params filtrés
    @contact = Contact.new(contact_params)

    # Si le formulaire est valide (validations du modèle Contact OK)…
    if @contact.valid?
      # …on envoie l'email de manière synchrone (deliver_now).
      # deliver_now suffit ici : pas besoin de job background pour un portfolio.
      ContactMailer.new_message(@contact).deliver_now
      # Message de succès (traduit) affiché sur la home, puis redirection vers la section contact
      redirect_to root_path(anchor: "contact"),
                  notice: t("contact.success")
    else
      # Si invalide, on réaffiche la home avec les erreurs.
      # On recharge les projets car la home en a besoin pour la section projets.
      @projects = Project.all
      flash.now[:alert] = t("contact.error")
      render "pages/home", status: :unprocessable_entity
    end
  end

  private

  # Strong parameters : on n'autorise que les champs attendus du formulaire.
  # Protection contre l'injection de paramètres non désirés.
  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
