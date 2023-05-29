function renderCorrectOption() {
  var x = event.srcElement.nextElementSibling
  while(x) {
    if(x.matches('#correctOption')) {
      if (x.style.display === "none") {
        x.style.display = "block";
        event.srcElement.innerHTML = "Hide Correct Option"
        event.srcElement.className = "btn-danger"
      } else {
        x.style.display = "none";
        event.srcElement.innerHTML = "Show Correct Option"
        event.srcElement.className = "btn-success"
      }
    }
    x = x.nextElementSibling
  }
}
