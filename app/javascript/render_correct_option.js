function renderCorrectOption() {
  var x = document.getElementById("correctOption");
  if (x.style.display === "none") {
    x.style.display = "block";
    document.getElementById("correctOptionButton").innerHTML = "Hide Correct Option"
    document.getElementById("correctOptionButton").className = "btn-danger"
  } else {
    x.style.display = "none";
    document.getElementById("correctOptionButton").innerHTML = "Show Correct Option"
    document.getElementById("correctOptionButton").className = "btn-success"
  }
}
