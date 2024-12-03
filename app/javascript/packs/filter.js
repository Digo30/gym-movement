document.addEventListener("DOMContentLoaded", () => {
  const distanceSlider = document.querySelector("#distance");
  const distanceValue = document.querySelector("#distance_value");
  const capacitySlider = document.querySelector("#capacity");
  const capacityValue = document.querySelector("#capacity_value");

  if (distanceSlider && distanceValue) {
    distanceSlider.addEventListener("input", () => {
      distanceValue.textContent = distanceSlider.value;
    });
  }

  if (capacitySlider && capacityValue) {
    capacitySlider.addEventListener("input", () => {
      capacityValue.textContent = capacitySlider.value;
    });
  }
});
