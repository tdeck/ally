var SESSION_CHECK_INTERVAL_MS = 20000;

function checkForSession() {
  var modal = document.getElementById('session-saver-overlay');

  fetch('/session')
    .then(response => response.json())
    .then(function(data) {
      // We use near_expiry to provide a grace period so that the session won't expire between
      // the next check and hitting submit
      if (data.valid && !data.near_expiry) {
        modal.style.display = 'none';
      } else {
        modal.style.display = 'block';
      }
    });
}

document.addEventListener("turbolinks:load", function() {
  if (!window.session_check_interval) {
    window.session_check_interval = setInterval(checkForSession, SESSION_CHECK_INTERVAL_MS);
  }

});

// If someone signs in from another tab and then returns, or reopens a new tab,
// this should trigger a refresh of the session status
document.addEventListener("visibilitychange", checkForSession);
