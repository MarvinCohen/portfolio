import { Controller } from "@hotwired/stimulus"

// typewriter_controller — effet "machine à écrire" :
// écrit une phrase lettre par lettre, marque une pause, l'efface,
// puis passe à la suivante, en boucle.
//
// Utilisation :
//   data-controller="typewriter"
//   data-typewriter-phrases-value='["Phrase 1", "Phrase 2"]'  (JSON)
//   <span data-typewriter-target="output"></span>  → où s'affiche le texte
export default class extends Controller {
  // Cible : l'élément où le texte est écrit
  static targets = ["output"]
  // Valeur : le tableau de phrases à afficher (passé en JSON depuis la vue)
  static values = { phrases: Array }

  connect() {
    this.phraseIndex = 0   // Index de la phrase courante
    this.charIndex = 0     // Index de la lettre courante
    this.deleting = false  // true quand on est en train d'effacer
    this.tick()            // Démarre la boucle d'animation
  }

  // disconnect() : on annule le minuteur en cours si le contrôleur disparaît
  disconnect() {
    if (this.timeout) clearTimeout(this.timeout)
  }

  // tick() — une étape de l'animation (ajoute ou retire une lettre),
  // puis se rappelle elle-même après un délai (setTimeout).
  tick() {
    // Sécurité : s'il n'y a aucune phrase, on ne fait rien
    if (this.phrasesValue.length === 0) return

    // Phrase actuellement ciblée
    const current = this.phrasesValue[this.phraseIndex]

    if (this.deleting) {
      // Mode effacement : on enlève une lettre
      this.charIndex--
    } else {
      // Mode écriture : on ajoute une lettre
      this.charIndex++
    }

    // On met à jour le texte affiché (sous-chaîne de la phrase)
    this.outputTarget.textContent = current.substring(0, this.charIndex)

    // Vitesse : écriture ~70ms/lettre, effacement plus rapide ~40ms
    let delay = this.deleting ? 40 : 70

    if (!this.deleting && this.charIndex === current.length) {
      // Phrase entièrement écrite → pause longue avant d'effacer
      delay = 1800
      this.deleting = true
    } else if (this.deleting && this.charIndex === 0) {
      // Phrase entièrement effacée → on passe à la phrase suivante
      this.deleting = false
      // L'opérateur modulo (%) fait revenir à 0 après la dernière phrase (boucle)
      this.phraseIndex = (this.phraseIndex + 1) % this.phrasesValue.length
      delay = 300
    }

    // On planifie la prochaine étape
    this.timeout = setTimeout(() => this.tick(), delay)
  }
}
