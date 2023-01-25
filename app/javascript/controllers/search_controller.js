import { Controller } from "stimulus";
let debounce = require("lodash/debounce");

export default class extends Controller {
  static targets = ["term"]

  initialize() {
    this.search = debounce(this.search, 750).bind(this);
  }

  search() {
      const term = this.termTarget.value
      const url = `/v?s=${term}`
      window.location = url
    }
}
