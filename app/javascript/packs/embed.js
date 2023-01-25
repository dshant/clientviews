import "../embed/style.css";
import React from "react";
import { render } from "react-dom";
import { Modal } from "../embed/components/Modal";
import yoha from "../embed/yoha";

window._userveys = _userveys;
// window._userveysQueue = window._userveysQueue || [];

function _userveys(name, params) {
  return Userveys[name](params);
}

const App = ({ surveyId, scriptSrc, visitorId }) => (
  <Modal id={surveyId} scriptSrc={scriptSrc} visitorId={visitorId} />
);

let loadEvent = "DOMContentLoaded";

if (typeof Turbolinks === "object" && Turbolinks.supported) {
  loadEvent = "turbolinks:load";
} else if (typeof Turbo === "object" && Turbo.supported) {
  loadEvent = "turbo:load";
}

document.addEventListener(loadEvent, async () => {
  if (window?.Userveys?.setup?.id == null) {
    console.error(
      "Please copy code snippet from the Dashboard to include survey setup"
    );
    return;
  }

  if (document.getElementById("u-wrapper")) {
    if (document.getElementById("u-wrapper").dataset.noJs === "true") {
      return;
    }
  }
  let scriptSrc = "http://localhost:5150";
  if (!document.getElementById("userveys-js")) {
    return;
  }
  const scriptUrlPath = new URL(document.getElementById("userveys-js").src);
  let host = scriptUrlPath.host;
  if (host.match("assets")) {
    host = "app.userveys.com";
  }
  scriptSrc = `${scriptUrlPath.protocol}//${host}`;

  const visitorId = yoha.getVisitorId();

  const htmlBody = document.body;
  const uWrapper = document.createElement("div");
  uWrapper.id = "u-wrapper";
  htmlBody.append(uWrapper);
  render(
    <App
      surveyId={window.Userveys.setup.id}
      scriptSrc={scriptSrc}
      visitorId={visitorId}
    />,
    document.getElementById("u-wrapper")
  );

  yoha.configure({
    visitsUrl: `${scriptSrc}/u/c/visits`,
    identifyUrl: `${scriptSrc}/u/c/identify`,
    eventsUrl: `${scriptSrc}/u/c/events`,
  });

  yoha.createVisit(window.Userveys.setup.id);
});

window.Userveys.display = (id) => {
  const event = new Event(`survey.${id}.display`);
  window.dispatchEvent(event);
};

window.Userveys.hide = (id) => {
  const event = new Event(`survey.${id}.hide`);
  window.dispatchEvent(event);
};

window.Userveys.identify = (data) => {
  yoha.identify(data);
};

window.Userveys.event = (event) => {
  yoha.createEvent(event);
};
