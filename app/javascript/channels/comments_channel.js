import consumer from "channels/consumer"

consumer.subscriptions.create("CommentsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const quizElement = document.querySelector(".all_comments")
    if(document.querySelector('#quiz-id').getAttribute('data-quiz-id') != String(data.quiz_id)) return;
    if (quizElement) {
      quizElement.innerHTML = data.html
    }
  }
});
