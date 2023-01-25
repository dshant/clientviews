import React, { useContext } from "react";

export function Footer({handleSubmit}) {

  return (
    <footer className="modal__footer">
      <button className="modal__btn modal__btn-primary" style={{width: '100%'}} onClick={handleSubmit}>
        Send Feedback
      </button>
    </footer>
  );
}
