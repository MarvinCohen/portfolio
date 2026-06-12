import { Controller } from "@hotwired/stimulus"

// cv_controller — gère l'ouverture et la fermeture du panneau CV qui "pop".
//
// Utilisation : data-controller="cv" sur le <body>.
//   - le bouton de la nav porte data-action="cv#open"
//   - le panneau (partial _cv) porte data-cv-target="panel"
//   - le voile et le bouton ✕ portent data-action="cv#close"
//
// L'animation visuelle est entièrement gérée par le CSS (_cv.scss) : on se
// contente d'ajouter/retirer la classe .is-open sur le panneau, le CSS s'occupe
// du fondu et de l'effet de pop.
export default class extends Controller {
  // Déclare la cible "panel" : Stimulus crée alors this.panelTarget.
  static targets = ["panel"]

  // open — affiche le panneau CV.
  // @param event [Event] le clic sur le bouton CV (on bloque son comportement par défaut)
  open(event) {
    // On évite que le bouton ne déclenche autre chose (ex: soumission de formulaire).
    event.preventDefault()

    // Classe qui déclenche l'apparition animée du panneau (voir CSS).
    this.panelTarget.classList.add("is-open")
    // Accessibilité : le panneau n'est plus caché aux lecteurs d'écran.
    this.panelTarget.setAttribute("aria-hidden", "false")

    // On empêche la page derrière le panneau de défiler tant qu'il est ouvert.
    document.body.style.overflow = "hidden"

    // On écoute la touche Échap pour fermer. On garde une référence liée (bind)
    // afin de pouvoir retirer exactement le même écouteur à la fermeture.
    this._onKeydown = this._handleKeydown.bind(this)
    document.addEventListener("keydown", this._onKeydown)
  }

  // close — masque le panneau CV.
  close() {
    // Retire la classe d'ouverture : le CSS rejoue la transition en sens inverse.
    this.panelTarget.classList.remove("is-open")
    // Accessibilité : on re-cache le panneau aux lecteurs d'écran.
    this.panelTarget.setAttribute("aria-hidden", "true")

    // On rétablit le défilement normal de la page.
    document.body.style.overflow = ""

    // On retire l'écouteur clavier pour ne pas l'accumuler à chaque ouverture.
    if (this._onKeydown) {
      document.removeEventListener("keydown", this._onKeydown)
      this._onKeydown = null
    }
  }

  // print — déclenche la boîte d'impression du navigateur pour enregistrer le
  // CV en PDF. La feuille @media print (_cv.scss) masque tout le site et ne
  // laisse apparaître que le panneau CV, repassé en thème clair. L'utilisateur
  // n'a plus qu'à choisir « Enregistrer au format PDF » comme destination.
  print() {
    window.print()
  }

  // _handleKeydown — ferme le panneau quand l'utilisateur appuie sur Échap.
  // @param event [KeyboardEvent]
  _handleKeydown(event) {
    if (event.key === "Escape") this.close()
  }

  // disconnect — sécurité : si le contrôleur est retiré du DOM alors que le
  // panneau est ouvert, on nettoie l'écouteur clavier et le style du body.
  disconnect() {
    if (this._onKeydown) {
      document.removeEventListener("keydown", this._onKeydown)
      this._onKeydown = null
    }
    document.body.style.overflow = ""
  }
}
