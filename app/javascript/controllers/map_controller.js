import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    userLocation: Object,
    distance: Number,
    capacity: Number,
    amenities: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue;

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    });

    this.addUserLocation();
  }

  addUserLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(position => {
        const userLat = position.coords.latitude;
        const userLng = position.coords.longitude;

        if (!isNaN(userLat) && !isNaN(userLng)) {
          this.userLocationValue = { lat: userLat, lng: userLng };

          new mapboxgl.Marker({
            element: this.createUserIcon()
          })
          .setLngLat([userLng, userLat])
          .addTo(this.map);

          this.addMarkersToMap();
          this.fitMapToMarkers();
        }
      }, error => {
        console.error("Erro ao obter localização:", error);
      });
    } else {
      console.error("Geolocalização não suportada.");
    }
  }

  addMarkersToMap() {
    if (!this.userLocationValue) {
      console.error("Localização do usuário não disponível");
      return;
    }

    const { lat: userLat, lng: userLng } = this.userLocationValue;

    console.log("User Location:", this.userLocationValue);
    console.log("Markers:", this.markersValue);
    console.log("Capacity Filter:", this.capacityValue);
    console.log("Amenities Filter:", this.amenitiesValue);
    console.log("Distance Filter:", this.distanceValue);

    this.markersValue.forEach(marker => {
      console.log("Marker:", marker);
    });

    const filteredMarkers = this.markersValue.filter(marker => {
      const capacityFilter = this.capacityValue <= marker.capacity;
      const amenitiesFilter = this.amenitiesValue.every(amenity => marker.amenities.includes(amenity));
      const distanceFilter = this.calculateDistance(userLat, userLng, marker.lat, marker.lng) <= this.distanceValue;
      console.log(`Filtering marker: ${marker.name}, Capacity: ${capacityFilter}, Amenities: ${amenitiesFilter}, Distance: ${distanceFilter}, Distance Value: ${this.calculateDistance(userLat, userLng, marker.lat, marker.lng)}`);
      return capacityFilter && amenitiesFilter && distanceFilter;
    });

    console.log("Filtered Markers:", filteredMarkers);

    filteredMarkers.forEach((marker) => {
      if (!isNaN(marker.lat) && !isNaN(marker.lng)) {
        console.log("Adding marker:", marker);
        const popup = new mapboxgl.Popup().setHTML(marker.info_window_html);

        new mapboxgl.Marker({
          element: this.createAcademyIcon()
        })
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map);
      }
    });

    // Ajustar o mapa com base nos marcadores filtrados e na localização do usuário
    this.fitMapToMarkers([{ lat: userLat, lng: userLng }, ...filteredMarkers]);
  }

  fitMapToMarkers(markers) {
    const bounds = new mapboxgl.LngLatBounds();
    markers.forEach(marker => bounds.extend([marker.lng, marker.lat]));
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
  }

  calculateDistance(lat1, lng1, lat2, lng2) {
    const toRad = (value) => value * Math.PI / 180;
    const R = 6371;

    const dLat = toRad(lat2 - lat1);
    const dLng = toRad(lng2 - lng1);

    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
              Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
              Math.sin(dLng / 2) * Math.sin(dLng / 2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  createUserIcon() {
    const div = document.createElement('div');
    div.className = 'user-marker';
    div.style.backgroundImage = 'url(https://cdn3.iconfinder.com/data/icons/map-navigation-8/512/location-pin-coordinate-point-512.png)';
    div.style.width = '50px';
    div.style.height = '50px';
    div.style.backgroundSize = 'cover';
    return div;
  }

  createAcademyIcon() {
    const div = document.createElement('div');
    div.className = 'academy-marker';
    div.style.backgroundImage = 'url(https://cdn-icons-png.freepik.com/512/5193/5193879.png)';
    div.style.width = '50px';
    div.style.height = '50px';
    div.style.backgroundSize = 'cover';
    return div;
  }
}
