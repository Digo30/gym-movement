var toggleAlunos = () => {
  let qtdAlunos = document.querySelectorAll(".img-checkin");
  let displayAlunos = document.querySelector(".qtd-alunos");

  qtdAlunos.length === 3 ? displayAlunos.classList.remove("d-none") : null;
};
toggleAlunos();

var checkFluxo = () => {
  let numeroFluxo = document.getElementById("fluxo");
  let detalheFluxo = document.getElementById("fluxo-detail");

  if (+numeroFluxo.innerText <= 40) {
    numeroFluxo.style.color = "green";
    detalheFluxo.style.color = "green";
  } else if (+numeroFluxo.innerText < 70) {
    numeroFluxo.style.color = "yellow";
    detalheFluxo.style.color = "yellow";
  } else {
    numeroFluxo.style.color = "red";
    detalheFluxo.style.color = "red";
  }
  console.log(+numeroFluxo.innerText);
};

checkFluxo();
