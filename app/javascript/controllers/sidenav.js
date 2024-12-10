document.addEventListener("turbo:load", function () {
  const menuToggle = document.getElementById("menu-toggle");
  const sidenav = document.getElementById("sidenav");
  const closeSidenav = document.getElementById("close-sidenav");

  // Inicializa a largura da sidenav para 0 ao carregar a página
  if (sidenav) {
    sidenav.style.width = "0";
  }

  if (menuToggle && sidenav && closeSidenav) {
    // Abre o menu
    menuToggle.addEventListener("click", () => {
      sidenav.style.width = "350px";
    });

    // Fecha o menu ao clicar no botão de fechar
    closeSidenav.addEventListener("click", () => {
      sidenav.style.width = "0";
    });

    // Fecha o menu se clicar fora da sidenav
    document.addEventListener("click", (event) => {
      if (!sidenav.contains(event.target) && !menuToggle.contains(event.target)) {
        sidenav.style.width = "0"; // Fecha o menu
      }
    });
  }
});
