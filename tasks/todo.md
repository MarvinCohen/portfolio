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

---

# Fonctionnalité : CV qui « pop » dans le style du portfolio

## Objectif
Ajouter un bouton « CV » dans la navigation. Au clic, un panneau plein écran
apparaît avec une animation cool (style écran tech / boot terminal), dans le
même univers néo-Tokyo que le site. Le CV est bilingue FR/EN et propose un
bouton « Télécharger en PDF ». Fermeture au clic dehors, touche Échap, ou ✕.

## Contenu du CV (repris du CV PDF, réorganisé)
- En-tête : Marvin COHEN, Développeur Web Full-Stack Ruby on Rails, Bordeaux,
  email, téléphone, LinkedIn, GitHub.
- Profil pro : full-stack RoR formé au Wagon, certifié RNCP niv. 6, 15 ans
  d'expérience en gestion d'équipes/projets.
- Expérience : Développeur Web (Biche., 2026, en cours), Chef de chantier BTP
  (CSE, 2021-2025), Commerçant indépendant (2018-2021), Chef d'équipe logistique
  / Agent de maîtrise (Exertis, 2010-2018).
- Projets : Teams-Up (co-fondateur, équipe de 4), Noctilio (solo).
- Formation : Concepteur Développeur d'Application Web (RNCP 6, Le Wagon, 2026),
  SST, Baccalauréat.
- Compétences : Back-end, Front-end, IA & intégrations, Outils & méthodes.
- Centres d'intérêt : sport, voyage, gaming.

## Fichiers impactés
- app/views/layouts/application.html.erb  (bouton « CV » dans la nav + rendu du partial modal)
- app/views/pages/_cv.html.erb            (NOUVEAU : structure du panneau CV)
- app/javascript/controllers/cv_controller.js (NOUVEAU : ouverture/fermeture, Échap, clic dehors, blocage du scroll)
- app/assets/stylesheets/_cv.scss         (NOUVEAU : style + animation du pop)
- app/assets/stylesheets/application.scss (ajout @use "cv")
- config/locales/fr.yml                   (clés cv.* + nav.cv)
- config/locales/en.yml                   (clés cv.* + nav.cv)
- public/cv-marvin-cohen.pdf              (NOUVEAU : copie du PDF pour le bouton télécharger)

## Animation envisagée
- Fond : voile sombre + flou qui apparaît en fondu.
- Panneau : « fenêtre terminal » (barre de titre avec pastilles + label mono),
  apparition par scale + léger glitch/scanline pour rester cohérent avec le site.
- Respect de prefers-reduced-motion (animation simplifiée si désactivée).

## Étapes
- [x] (PDF reporté) — voir section dédiée plus bas
- [x] Ajouter les traductions cv.* et nav.cv dans fr.yml et en.yml
- [x] Créer le partial app/views/pages/_cv.html.erb (panneau + contenu traduit)
- [x] Ajouter le bouton « CV » dans la nav et le rendu du partial dans le layout
- [x] Créer le contrôleur Stimulus cv_controller.js (open/close/Échap/clic dehors)
- [x] Créer _cv.scss (style + animation) et l'ajouter dans application.scss
- [x] Tester en local + déployer (CV en ligne sur www.marvincohen.fr)

---

# Fonctionnalité : Bouton « Télécharger PDF » du CV

## Objectif
Permettre de télécharger le CV en PDF depuis le panneau, via l'impression
navigateur (« Enregistrer au format PDF »). Méthode choisie : zéro dépendance,
fiable sur Railway, rendu fidèle au contenu du CV. Une feuille @media print
masque tout le site et ne laisse apparaître que le CV, repassé en thème clair
(fond blanc, texte foncé, accent vermillon conservé) pour une impression lisible.
Le téléphone n'apparaît QU'au PDF (masqué à l'écran), comme souhaité.

## Fichiers impactés
- config/locales/fr.yml + en.yml          (clés cv.download, cv.phone_label)
- app/views/pages/_cv.html.erb            (bouton « Télécharger PDF » + ligne téléphone print-only)
- app/javascript/controllers/cv_controller.js (méthode print → window.print)
- app/assets/stylesheets/_cv.scss         (style du bouton + bloc @media print)

## Étapes
- [x] Traductions cv.download et cv.phone_label (fr + en)
- [x] Bouton « Télécharger PDF » dans la barre du panneau + ligne téléphone print-only
- [x] Méthode print() dans cv_controller.js
- [x] Bloc @media print dans _cv.scss (thème clair, masquage du site, téléphone visible)
- [x] Compiler le SCSS (build OK) ; déploiement Railway
