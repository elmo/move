// To launch a modal, use the following code:

// <%= link_to "#",
//         class: "modal-trigger btn btn-primary",
//         data: {
//           action: "click->components--modal#launch",
//           modal_id: "unique-modal-id",
//           turbo: false
//         } do %>
//   Launch!
// <% end %>

// If the modal contains a video, to auto-play it when the modal launches, add data attribute play_video: "true" to the link.


import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modal"];
  static values = {};

  connect() {}

  launch(event) {
    var trigger = event.target.closest(".modal-trigger");
    var modal_id = trigger.dataset.modalId;
    var shouldPlayVideo = trigger.dataset.playVideo === "true";

    var modal = this.modalTargets.find((target) => target.id === modal_id);

    if (modal) {
      modal.classList.remove("hidden");

      // If should play video, find the iframe and play it
      if (shouldPlayVideo) {
        var iframe = modal.querySelector("iframe");
        if (iframe) {
          // Add autoplay=1 to the src URL
          var src = iframe.src;
          if (src.includes("?")) {
            src += "&autoplay=1";
          } else {
            src += "?autoplay=1";
          }
          iframe.src = src;
        }
      }
    }
  }

  close(event) {
    var modal_container = event.target.closest(".modal");
    if (modal_container) {
      this.reset(modal_container);
    }
  }

  clickOutsideHide(event) {
    var modal_container = event.target.closest(".modal");
    if (modal_container) {
      var modal_box = modal_container.querySelector(".modal-box");

      if (modal_box.contains(event.target) === false) {
        this.reset(modal_container);
      }
    }
  }

  reset(modal_container) {
    modal_container.classList.add("hidden");

    // If modal contains a video, then stop playback when modal is closed
    var video = modal_container.querySelector("iframe, video");
    if (video) {
      if (video.tagName.toLowerCase() === "video") {
        video.pause();
      } else {
        // For YouTube iframes, remove autoplay parameter to stop playback
        var src = video.src;
        src = src.replace(/[?&]autoplay=1/, '');
        video.src = src;
      }
    }
  }
}
