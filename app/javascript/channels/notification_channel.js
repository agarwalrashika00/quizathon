import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    var current_user_id = document.querySelector(".user-id").getAttribute("data-user-id");
    if(current_user_id != String(data.parent_comment_user_id)) return;

    var element = document.querySelector(".bi-bell")
    var intervalId;

    function blink() {
      intervalId = setInterval(function() {
        element.style.visibility = (element.style.visibility === 'hidden') ? 'visible' : 'hidden';
      }, 500);
    }

    function stopBlinking() {
      clearInterval(intervalId);
      element.style.visibility = 'visible';
    }

    element.addEventListener('click', stopBlinking);

    blink();
  }
});

