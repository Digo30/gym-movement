var toggleAlunos = () => {
  let qtdAlunos = document.querySelectorAll(".img-checkin");
  let displayAlunos = document.querySelector(".qtd-alunos");

  qtdAlunos.length === 3 ? displayAlunos.classList.remove("d-none") : null;
};
toggleAlunos();
