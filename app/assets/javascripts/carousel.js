var addClassActive = () => {
  const carouselList = document.querySelector(".lista-carousel");
  carouselList ? carouselList.firstElementChild.classList.add("active") : null;
};
addClassActive();
