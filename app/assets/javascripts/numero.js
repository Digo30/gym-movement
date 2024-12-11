const numerosAnimados = document.getElementById("numeros");
const incrementar = (numero) => {
  const numFinal = +numero.innerHTML;
  const incremento = numFinal / 600;
  let somador = 0;
  const intervalo = setInterval(() => {
    somador = somador + incremento;
    numero.innerHTML = parseInt(somador);
    if (numFinal < somador) {
      numero.innerHTML = numFinal;
      clearInterval(intervalo);
    }
  });
};
incrementar(numerosAnimados);
