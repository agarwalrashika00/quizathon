document.addEventListener("DOMContentLoaded", function () {
  var countdownElement = document.getElementById("countdown");
  var countdownValue = parseInt(countdownElement.innerHTML);
  var quizSlug = countdownElement.getAttribute('data-quiz-slug')
  var countdownInterval = setInterval(function () {
    countdownValue--;
    countdownElement.textContent = countdownValue;
    if (countdownValue === 0) {
      clearInterval(countdownInterval);
      window.location.href = `/quizzes/${quizSlug}/submit`;
    }
  }, 1000);
});
