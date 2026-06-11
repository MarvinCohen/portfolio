# Portfolio Marvin Cohen — Plan

## Objectif
Créer un portfolio one-page (style "japonais tech") en Ruby on Rails pour
présenter mes compétences, mes projets et permettre de me contacter.

## Direction artistique
- Style néo-Tokyo épuré : fond très sombre, accent vermillon (朱) + cyan
- Typo : Space Grotesk (titres) + Inter (texte) + JetBrains Mono (labels) + Zen Kaku Gothic (japonais)
- Labels de sections en kanji, numéros 01/02/03/04, lignes de grille, scanline

## Fichiers impactés
- config/routes.rb (root + contacts)
- app/controllers/pages_controller.rb, contacts_controller.rb
- app/models/contact.rb (objet de formulaire ActiveModel, pas en base)
- app/mailers/contact_mailer.rb + vues email
- app/views/layouts/application.html.erb (polices, nav, scanline)
- app/views/pages/home.html.erb + partials (_hero, _projects, _skills, _about, _contact)
- app/assets/stylesheets/ (design system SCSS découpé en partials)
- app/javascript/controllers/ (reveal, typewriter)
- test/controllers/ (tests pages + contacts)

## Étapes
- [x] Créer l'app Rails (PostgreSQL) + dartsass-rails
- [x] Design system SCSS japonais tech (tokens, base, layout, sections, animations)
- [x] PagesController + routes + structure home
- [x] Partials des sections (hero, projets, compétences, à propos, contact)
- [x] Contrôleurs Stimulus (apparition au scroll + machine à écrire)
- [x] Formulaire de contact + ContactMailer
- [x] Tests minitest (5 tests, 0 failure)

## Reste à faire (avant mise en ligne)
- [ ] Configurer un SMTP réel (ex: Gmail/Sendgrid) pour que le formulaire envoie vraiment les emails
- [ ] Déployer sur Railway (comme Noctilio) + nom de domaine
- [ ] Ajouter une favicon / icône personnalisée (app/assets ou public/icon.svg)
- [ ] (Optionnel) Captures d'écran des projets dans les cartes
- [ ] (Optionnel) Lien vers une démo en ligne de Teams Up si déployé

## Notes
- `rails test` est réécrit en `rake test` par le hook RTK et affiche "no tests ran".
  Lancer les tests avec un chemin explicite : `rails test test/controllers/`
