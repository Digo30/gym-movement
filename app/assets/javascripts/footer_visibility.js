document.addEventListener("turbo:load", function() {
  let lastScrollTop = 0;
  const footer = document.querySelector('footer');

  window.addEventListener('scroll', function() {
    let scrollTop = window.pageYOffset || document.documentElement.scrollTop;

    if (scrollTop > lastScrollTop) {
      // Rolando para baixo
      footer.classList.add('hidden');
    } else {
      // Rolando para cima
      footer.classList.remove('hidden');
    }
    lastScrollTop = scrollTop;
  });
});
