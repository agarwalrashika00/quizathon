document.addEventListener('DOMContentLoaded', function() {
  var dropdownToggles = document.querySelectorAll('.dropdown-toggle');
  var dropdownMenu = document.querySelector('.dropdown-menu');

  for (var i = 0; i < dropdownToggles.length; i++) {
    dropdownToggles[i].addEventListener('click', function() {
      dropdownMenu.classList.toggle('show');
    });
  }

  document.addEventListener('click', function(e) {
    var target = e.target;
    var dropdownToggle = target.closest('.dropdown-toggle');

    if (!dropdownToggle) {
      dropdownMenu.classList.remove('show');
    }
  });
});
