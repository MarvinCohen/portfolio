import { Controller } from "@hotwired/stimulus"

// cursor_controller — curseur custom : un point collé au pointeur
// + un anneau qui le suit avec un léger retard (effet élastique).
// L'anneau grossit au survol des éléments interactifs (liens, boutons).
//
// Utilisation : data-controller="cursor" sur le <body>,
// avec deux éléments cibles : "ring" (anneau) et "dot" (point).
export default class extends Controller {
  static targets = ["ring", "dot"]

  connect() {
    // Position réelle de la souris
    this.mouseX = window.innerWidth / 2
    this.mouseY = window.innerHeight / 2
    // Position interpolée de l'anneau (suit avec du retard)
    this.ringX = this.mouseX
    this.ringY = this.mouseY

    // Drapeau : tant que la souris n'a pas bougé depuis cette (re)connexion,
    // on ne connaît pas sa vraie position. Sans ça, après une navigation Turbo
    // (clic sur un lien de section), le contrôleur se reconnecte avec une
    // position périmée (centre de l'écran) et l'anneau "se téléporte" au
    // premier mouvement. On masque donc le curseur jusqu'au 1er mouvement, puis
    // on le recale d'un coup sur la vraie position (voir onMove).
    this.hasMoved = false
    this.dotTarget.style.opacity = "0"
    this.ringTarget.style.opacity = "0"

    // On garde des références aux fonctions pour pouvoir les retirer plus tard
    this.onMove = this.onMove.bind(this)
    this.onOver = this.onOver.bind(this)
    this.onOut = this.onOut.bind(this)

    document.addEventListener("mousemove", this.onMove)
    document.addEventListener("mouseover", this.onOver)
    document.addEventListener("mouseout", this.onOut)

    // Démarre la boucle d'animation (rendu fluide via requestAnimationFrame)
    this.raf = requestAnimationFrame(() => this.render())
  }

  disconnect() {
    // Nettoyage : on retire les écouteurs et on stoppe la boucle
    document.removeEventListener("mousemove", this.onMove)
    document.removeEventListener("mouseover", this.onOver)
    document.removeEventListener("mouseout", this.onOut)
    cancelAnimationFrame(this.raf)
  }

  // Mémorise la position de la souris à chaque mouvement
  onMove(e) {
    this.mouseX = e.clientX
    this.mouseY = e.clientY

    // Premier mouvement depuis la (re)connexion : on cale l'anneau directement
    // sur la souris (au lieu de le laisser glisser depuis le centre périmé) et
    // on réaffiche les deux éléments. Plus aucune "téléportation" visible.
    if (!this.hasMoved) {
      this.hasMoved = true
      this.ringX = this.mouseX
      this.ringY = this.mouseY
      this.dotTarget.style.opacity = ""
      this.ringTarget.style.opacity = ""
    }

    // Le point suit instantanément le pointeur
    this.dotTarget.style.transform =
      `translate(${this.mouseX}px, ${this.mouseY}px) translate(-50%, -50%)`
  }

  // Au survol d'un élément interactif → l'anneau passe en mode "actif"
  onOver(e) {
    if (e.target.closest("a, button, .btn, input, textarea")) {
      this.ringTarget.classList.add("cursor-ring--active")
    }
  }
  // En quittant l'élément → retour à la normale
  onOut(e) {
    if (e.target.closest("a, button, .btn, input, textarea")) {
      this.ringTarget.classList.remove("cursor-ring--active")
    }
  }

  // Boucle d'animation : l'anneau rattrape progressivement la souris.
  render() {
    // Interpolation linéaire (lerp) : on avance de 18% vers la cible à chaque frame
    this.ringX += (this.mouseX - this.ringX) * 0.18
    this.ringY += (this.mouseY - this.ringY) * 0.18
    this.ringTarget.style.transform =
      `translate(${this.ringX}px, ${this.ringY}px) translate(-50%, -50%)`
    this.raf = requestAnimationFrame(() => this.render())
  }
}
