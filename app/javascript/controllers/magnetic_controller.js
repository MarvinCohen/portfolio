import { Controller } from "@hotwired/stimulus"

// magnetic_controller — effet "aimant" : le bouton se décale légèrement
// vers le pointeur quand la souris passe dessus, puis revient à sa place.
//
// Utilisation : data-controller="magnetic" directement sur le bouton/lien.
export default class extends Controller {
  connect() {
    this.onMove = this.onMove.bind(this)
    this.onLeave = this.onLeave.bind(this)
    this.element.addEventListener("mousemove", this.onMove)
    this.element.addEventListener("mouseleave", this.onLeave)
  }

  disconnect() {
    this.element.removeEventListener("mousemove", this.onMove)
    this.element.removeEventListener("mouseleave", this.onLeave)
  }

  // Calcule le décalage en fonction de la position de la souris
  // par rapport au centre de l'élément.
  onMove(e) {
    // getBoundingClientRect = position et taille de l'élément à l'écran
    const rect = this.element.getBoundingClientRect()
    // Distance entre la souris et le centre de l'élément
    const dx = e.clientX - (rect.left + rect.width / 2)
    const dy = e.clientY - (rect.top + rect.height / 2)
    // On applique un déplacement atténué (30%) → effet subtil
    this.element.style.transform = `translate(${dx * 0.3}px, ${dy * 0.3}px)`
  }

  // À la sortie, on remet le bouton à sa position d'origine, en douceur
  onLeave() {
    this.element.style.transform = "translate(0, 0)"
  }
}
