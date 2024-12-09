function scrollToBottom() {
  var messagesContainer = document.getElementById("messages-container2");
  const chatInput = document.querySelector(".chat-input");
  messagesContainer.scrollTop = messagesContainer.scrollHeight;
  window.scrollTo({ top: chatInput.getBoundingClientRect().top + window.scrollY + 100 });
}

window.addEventListener("load", function () {
  scrollToBottom();
});

document.addEventListener("turbo:submit-end", function () {
  console.log("Evento turbo:submit-end disparado");
  console.log(window);
  setTimeout(scrollToBottom, 100);
});
