import { Application } from "@hotwired/stimulus"

const application = Application.start()

// stimulus-autocomplete設定用
import { Autocomplete } from 'stimulus-autocomplete'
application.register('autocomplete', Autocomplete)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
