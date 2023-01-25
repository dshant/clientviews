// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";

window.$ = global.$ = require("jquery");
window.jQuery = global.jQuery = require("jquery");
require("jquery-serializejson");

Rails.start();
Turbolinks.start();
ActiveStorage.start();

import "controllers";
import "bootstrap/dist/js/bootstrap";

require("trix");
require("@rails/actiontext");

require("chartkick/chart.js");

import LocalTime from "local-time";
LocalTime.start();

require("@nathanvda/cocoon");

import React from "react";
import { render } from "react-dom";
import { Modal } from "../embed/components/Modal";
import { Reply } from "../embed/components/Reply";

import ClipboardJS from "clipboard";

let event = "DOMContentLoaded";

if (typeof Turbolinks == "object" && Turbolinks.supported) {
  event = "turbolinks:load";
} else if (typeof Turbo == "object" && Turbo.supported) {
  event = "turbo:load";
}

document.addEventListener(event, function namedListener() {
  const clippy = new ClipboardJS(".btn-copy");
  clippy.on("success", function (e) {
    e.clearSelection();
    console.info("Action:", e.action);
    console.info("Text:", e.text);
    console.info("Trigger:", e.trigger);
    // showTooltip(e.trigger, "Copied!");
    const btn = $(e.trigger);
    setTooltip(btn, "Copied");
    hideTooltip(btn);
  });

  $(".btn-copy").tooltip({
    trigger: "click",
    placement: "right",
    boundary: "window",
  });

  const tagList = $("#js-tag-list").select2({
    placeholder: "Add Tags to the Response",
    tags: true,
  });
  // const items = $(".tag-list-text").val().split(",");
  // console.log("I", items, tagList);
  // tagList.val(items);
  // tagList.trigger("change.select2");

  function setTooltip(btn, message) {
    btn.tooltip("hide").attr("data-original-title", message).tooltip("show");
  }

  function hideTooltip(btn) {
    setTimeout(function () {
      btn.tooltip("hide");
    }, 1000);
  }

  $('[data-toggle="tooltip"]').tooltip();

  $("a[disabled=disabled]").click(function (event) {
    event.preventDefault(); // Prevent link from following its href
  });

  $("#user-dropdown").on("shown.bs.dropdown", function () {
    $("#user-dropdown .chev")
      .addClass("fa-chevron-up")
      .removeClass("fa-chevron-down");
  });

  $("#user-dropdown").on("hidden.bs.dropdown", function () {
    $("#user-dropdown .chev")
      .addClass("fa-chevron-down")
      .removeClass("fa-chevron-up");
  });

  let preview = true;
  if (window.location.pathname.match("/p/")) {
    preview = false;
  }

  const App = ({ surveyId, scriptSrc }) => (
    <Modal id={surveyId} scriptSrc={scriptSrc} preview={preview} />
  );

  const surveyId = window.location.pathname.split("/")[2];

  if (document.getElementById("u-wrapper") && surveyId) {
    render(
      <App
        surveyId={surveyId}
        scriptSrc={`${window.location.protocol}//` + window.location.host}
      />,
      document.getElementById("u-wrapper")
    );
    setTimeout(() => {
      Turbolinks.clearCache();
      const event = new Event(`survey.${surveyId}.display`);
      window.dispatchEvent(event);
    }, 50);
  }
});
