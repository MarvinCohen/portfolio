import { Controller } from "@hotwired/stimulus"

// reveal_controller — fait apparaître les éléments en fondu quand ils
// entrent dans la zone visible de l'écran (au scroll).
//
// Utilisation : data-controller="reveal" sur un conteneur (ex: <main>).
// Tout descendant portant l'attribut [data-reveal] sera animé.
// Le CSS (_animations.scss) gère le rendu : [data-reveal] est invisible,
// puis on lui ajoute la classe .is-visible pour le révéler.
export default class extends Controller {
  // connect() est appelé automatiquement par Stimulus quand le contrôleur
  // est attaché à l'élément dans le DOM.
  connect() {
    // On récupère tous les éléments à animer à l'intérieur du conteneur.
    const items = this.element.querySelectorAll("[data-reveal]")

    // L'IntersectionObserver surveille quand un élément entre dans l'écran.
    // C'est plus performant qu'écouter l'événement scroll en continu.
    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          // isIntersecting = true quand l'élément devient visible à l'écran
          if (entry.isIntersecting) {
            // On ajoute la classe qui déclenche l'animation CSS
            entry.target.classList.add("is-visible")
            // Une fois révélé, on arrête de l'observer (animation jouée une seule fois)
            this.observer.unobserve(entry.target)
          }
        })
      },
      // L'élément est considéré visible dès que 12% est dans l'écran
      { threshold: 0.12 }
    )

    // On démarre l'observation sur chaque élément
    items.forEach((item) => this.observer.observe(item))
  }

  // disconnect() est appelé quand le contrôleur est retiré du DOM.
  // On nettoie l'observer pour éviter les fuites mémoire.
  disconnect() {
    if (this.observer) this.observer.disconnect()
  }
}
