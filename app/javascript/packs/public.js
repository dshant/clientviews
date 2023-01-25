import React from "react";
import { render } from "react-dom";
import { Modal } from "../embed/components/Modal";

const App = ({ surveyId, scriptSrc, preview }) => (
  <Modal id={surveyId} scriptSrc={scriptSrc} />
);

let event = "DOMContentLoaded";

if (typeof Turbolinks == "object" && Turbolinks.supported) {
  event = "turbolinks:load";
} else if (typeof Turbo == "object" && Turbo.supported) {
  event = "turbo:load";
}

const surveyId = window.location.pathname.split("/")[2];

$(document).one(event, () => {
  if (document.getElementById(`modal-${surveyId}`)) {
    return;
  }
  if (document.getElementById("u-wrapper")) {
    render(
      <App
        surveyId={surveyId}
        scriptSrc={`${window.location.protocol}//` + window.location.host}
      />,
      document.getElementById("u-wrapper")
    );
    setTimeout(() => {
      const event = new Event(`survey.${surveyId}.display`);
      window.dispatchEvent(event);
    }, 250);
  }
});
