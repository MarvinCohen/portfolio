# Configuration du service d'envoi d'emails Resend.
# Resend envoie les mails via une API HTTPS (port 443), ce qui contourne le
# blocage des ports SMTP sortants imposé par Railway sur ses plans Trial/Hobby.
#
# La clé API est lue depuis une variable d'environnement (RESEND_API_KEY) pour
# ne jamais l'écrire en dur dans le code. En développement/test elle peut être
# absente : ce n'est pas un problème car la méthode d'envoi :resend n'est
# activée qu'en production (voir config/environments/production.rb).
Resend.api_key = ENV["RESEND_API_KEY"]
