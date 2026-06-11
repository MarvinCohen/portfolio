# Déploiement sur Railway

Guide pas à pas pour mettre le portfolio en ligne sur Railway.
Railway détecte automatiquement le `Dockerfile` à la racine et construit l'image.

## 1. Pré-requis

- Un compte Railway (https://railway.app), connecté à ton compte GitHub.
- Le projet poussé sur un dépôt GitHub.
- La clé `config/master.key` (générée par Rails). NE JAMAIS la committer :
  elle est déjà dans `.gitignore`. On la fournira à Railway en variable.

## 2. Créer le projet et la base de données

1. Sur Railway : `New Project` puis `Deploy from GitHub repo`, choisis ce dépôt.
2. Dans le projet Railway : `New` puis `Database` puis `Add PostgreSQL`.
   Railway crée une base et expose la variable `DATABASE_URL` automatiquement.
3. Sur le service de l'app (pas la base), onglet `Variables` : vérifie que
   `DATABASE_URL` est bien référencée (Railway la partage entre les services
   du même projet ; sinon, ajoute-la en référence à celle de la base Postgres).

## 3. Variables d'environnement à définir

Sur le service de l'app, onglet `Variables`, ajouter :

| Variable             | Valeur                                                        |
|----------------------|---------------------------------------------------------------|
| `RAILS_MASTER_KEY`   | Le contenu du fichier `config/master.key` (une longue chaîne) |
| `APP_HOST`           | Le domaine public, ex `portfolio-marvin.up.railway.app` (sans https://) |
| `GMAIL_USERNAME`     | Ton adresse Gmail (ex `marvincohen95@gmail.com`)              |
| `GMAIL_APP_PASSWORD` | Un "mot de passe d'application" Google (voir section 4)       |
| `RAILS_LOG_LEVEL`    | `info` (facultatif)                                           |

`DATABASE_URL` est fournie par Railway, ne pas la saisir à la main.

## 4. Mot de passe d'application Gmail (pour le formulaire de contact)

Le formulaire envoie un email via le serveur SMTP de Gmail. Gmail refuse le
mot de passe habituel : il faut un "mot de passe d'application".

1. Active la validation en 2 étapes sur ton compte Google.
2. Va sur https://myaccount.google.com/apppasswords.
3. Crée un mot de passe d'application (nom libre, ex "Portfolio").
4. Copie les 16 caractères générés dans la variable `GMAIL_APP_PASSWORD`.

## 5. Domaine public

1. Sur le service de l'app : onglet `Settings` puis `Networking`.
2. Clique `Generate Domain` : Railway crée une URL `*.up.railway.app`.
3. Reporte ce domaine dans la variable `APP_HOST` (sans `https://`).
4. Mets aussi ce domaine dans `public/robots.txt` à la place de `TON-DOMAINE`
   (ligne `Sitemap:`), puis committe et pousse.

## 6. Base de données : migrations automatiques

Le fichier `bin/docker-entrypoint` lance `bin/rails db:prepare` au démarrage :
la base est créée et migrée automatiquement à chaque déploiement. Aucune
commande manuelle n'est nécessaire.

## 7. Vérifications après déploiement

- Ouvre l'URL : la home doit s'afficher en HTTPS.
- `/up` doit répondre (contrôle de santé interne de Railway).
- Teste le formulaire de contact : tu dois recevoir l'email.
- `/sitemap.xml` doit lister la home et les 3 pages projets.
- Partage le lien (Slack, LinkedIn) : l'aperçu doit montrer l'image
  `og-image.png` et le titre du site.

## Notes techniques (pour comprendre)

- **Une seule base PostgreSQL** : Rails 8 utilise le stack "Solid" (cache,
  jobs, websockets en base). Les 4 configurations (`primary`, `cache`,
  `queue`, `cable`) pointent toutes vers la même base Railway
  (voir `config/database.yml`). Leurs tables cohabitent sans conflit.
- **HTTPS forcé** : `config.force_ssl = true` et `config.assume_ssl = true`
  dans `config/environments/production.rb`. Railway termine le SSL en amont.
- **Hôtes autorisés** : seules les requêtes vers `*.up.railway.app` et le
  domaine `APP_HOST` sont acceptées (protection contre le DNS rebinding).
- **Emails synchrones** : `deliver_now` envoie l'email pendant la requête,
  donc aucun worker de jobs en arrière-plan n'est à lancer.
