import React from "react";

export const Thanks = ({ survey }) => {
  return (
    <p style={{ textAlign: "center", fontSize: "1.25rem", fontWeight: 300 }}>
      {survey?.thank_you_note || "Thank you for your feedback!"}
    </p>
  );
};
