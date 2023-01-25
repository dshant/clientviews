import React from "react";
import { render } from "react-dom";
import { Reply } from "../embed/components/Reply";

require("trix");
require("@rails/actiontext");
import "controllers";

let event = "DOMContentLoaded";

if (typeof Turbolinks == "object" && Turbolinks.supported) {
  event = "turbolinks:load";
} else if (typeof Turbo == "object" && Turbo.supported) {
  event = "turbo:load";
}

// const surveyId = window.location.pathname.split("/")[2];

// $(document).on(event, () => {
//   if (document.getElementById("reply-js")) {
//     const replyId = document.getElementById("reply-js").dataset.replyId;
//     render(<Reply replyId={replyId} />, document.getElementById("reply-js"));
//   }
// });
