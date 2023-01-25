import { Controller } from "stimulus";
let debounce = require("lodash/debounce");

import "../embed/style.css";
import React from "react";
import ReactDOM, { render } from "react-dom";
import { Modal } from "../embed/components/Modal";

const App = ({ surveyId, scriptSrc, preview }) => (
  <Modal id={surveyId} scriptSrc={scriptSrc} preview={true} />
);

export default class extends Controller {
  initialize() {
    this.preview = debounce(this.preview, 750).bind(this);
  }

  connect() {
    window.tempImgData = null;
    const form = $(this.element);
    form.find("input#survey_avatar").on("change", function () {
      const input = this;
      if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
          window.tempImgData = e.target.result;
          form.find("img").first().attr("src", e.target.result);
          $("#top_content.img").attr("src", e.target.result);
        };

        reader.readAsDataURL(input.files[0]);
      }
    });
    this.element.addEventListener("trix-change", this.preview.bind(this));

    const surveyId = window.location.pathname.split("/")[2];

    // if (document.getElementById(`modal-${surveyId}`)) {
    //   return false;
    // }
    // if (document.getElementById("u-wrapper")) {
    //   render(
    //     <App
    //       surveyId={surveyId}
    //       scriptSrc={`${window.location.protocol}//` + window.location.host}
    //       preview={true}
    //     />,
    //     document.getElementById("u-wrapper")
    //   );
    //   setTimeout(() => {
    //     const event = new Event(`survey.${surveyId}.display`);
    //     window.dispatchEvent(event);
    //   }, 250);
    // }
  }

  disconnect() {
    this.element.removeEventListener("trix-change", this.preview.bind(this));
  }

  static targets = ["scale", "rating", "delay", "url"];
  static values = { id: String };

  change(e) {
    console.log(e.target.value);
    if (e.target.value === "scale" || e.target.value === "scale_w_text") {
      this.scaleTarget.classList.remove("d-none");
      this.ratingTarget.classList.add("d-none");
    }
    if (e.target.value === "rating" || e.target.value === "rating_w_text") {
      this.ratingTarget.classList.remove("d-none");
      this.scaleTarget.classList.add("d-none");
    }
  }

  changeTrigger(e) {
    console.log(e.target.value);
    if (e.target.value === "delay") {
      this.delayTarget.classList.remove("d-none");
      this.urlTarget.classList.add("d-none");
    }
    if (e.target.value === "url") {
      this.urlTarget.classList.remove("d-none");
      this.delayTarget.classList.add("d-none");
    }
  }

  preview(e) {
    const data = $(e.target)
      .parents("form")
      .find("input,select")
      .filter(function (index, element) {
        return element.name != "_method";
      })
      .serializeJSON();
    const mergedData = data;
    const id =
      this.idValue.split("_")[1] == "survey"
        ? "new"
        : this.idValue.split("_")[1];
    console.log("preview", `survey..preview`, mergedData);
    const previewEvent = new CustomEvent(`survey.${id}.preview`, {
      detail: { params: mergedData },
    });
    window.dispatchEvent(previewEvent);
  }
}
