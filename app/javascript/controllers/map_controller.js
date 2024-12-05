import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl' // Don't forget this!

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    capacity: Number,
    amenities: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    const filteredMarkers = this.markersValue.filter(marker => {
      const capacityFilter = this.capacityValue <= marker.capacity
      const amenitiesFilter = this.amenitiesValue.every(amenity => marker.amenities.includes(amenity))
      return capacityFilter && amenitiesFilter
    })

    filteredMarkers.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      new mapboxgl.Marker()
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup) // Conecta o popup ao marcador
        .addTo(this.map)
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([marker.lng, marker.lat]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
