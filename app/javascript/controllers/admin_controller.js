import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    console.log("admin");
  }

  load() {
    const userId = event.currentTarget.value;
    location.replace(
      `${window.location.origin}${window.location.pathname}?user_id=${userId}`
    );
  }
}
