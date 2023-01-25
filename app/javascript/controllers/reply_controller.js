import { Controller } from "stimulus";

export default class extends Controller {
  connect() {}

  showTrix(e) {
    e.preventDefault();
    $("#reply_form, #reply-show").toggle();
  }
}
