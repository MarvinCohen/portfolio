import { Controller } from "@hotwired/stimulus"

// scrollspy_controller — met en évidence le lien de navigation
// correspondant à la section actuellement visible à l'écran.
//
// Utilisation : data-controller="scrollspy" sur la <nav>.
// Le contrôleur lit les liens d'ancre (href="#id") et observe
// les sections correspondantes.
export default class extends Controller {
  connect() {
    // On récupère les liens de nav contenant une ancre (#...).
    // Les href sont du type "/#projets" : link.hash renvoie "#projets".
    this.links = Array.from(this.element.querySelectorAll(".nav__links a"))
      .filter((link) => link.hash)

    // Pour chaque lien, on retrouve la section ciblée dans la page
    const sections = this.links
      .map((link) => document.querySelector(link.hash))
      .filter((section) => section !== null)

    // Observe l'entrée/sortie des sections dans l'écran
    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            // La section visible → on active son lien
            this.activate(`#${entry.target.id}`)
          }
        })
      },
      // rootMargin négatif : une section est "active" quand elle occupe
      // la bande centrale de l'écran (et pas juste un bord).
      { rootMargin: "-45% 0px -45% 0px" }
    )

    sections.forEach((section) => this.observer.observe(section))
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }

  // Ajoute la classe .is-active au bon lien et la retire des autres
  activate(hash) {
    this.links.forEach((link) => {
      link.classList.toggle("is-active", link.hash === hash)
    })
  }
}
