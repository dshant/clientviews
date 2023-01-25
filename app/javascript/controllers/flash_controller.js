import { Controller } from "stimulus";
import toastr from "toastr";

window.toastr = toastr

export default class extends Controller {

  static values = { key: String, msg: String }

  connect() {
    console.log('Flash', this);
    let flash_key = this.keyValue;
    let flash_value = this.msgValue;
    console.log(flash_key, flash_value);

    const options = {
      debug: true,
      positionClass: "toastr-top-right",
      onclick: null,
      showDuration: 300,
      hideDuration: 1000,
      timeOut: 5000,
      extendedTimeOut: 1000,
    };

    switch (flash_key) {
      case "notice":
      case "success":
        toastr.success(flash_value, options);
        break;
      case "info":
        toastr.info(flash_value, options);
        break;
      case "warning":
        toastr.warning(flash_value, options);
        break;
      case "alert":
      case "error":
        toastr.error(flash_value, options);
        break;
      default:
        toastr.success(flash_value, options);
    }
  }
}
