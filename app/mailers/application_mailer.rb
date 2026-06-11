class ApplicationMailer < ActionMailer::Base
  # Expéditeur par défaut de tous les emails de l'app
  default from: "portfolio@marvincohen.dev"
  layout "mailer"
end
