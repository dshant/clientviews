import React, { useEffect, useState, useContext } from "react";
import { FormContext } from "./Modal";

export function Scale({ survey }) {
  const [btnValue, setBtnValue] = useState(null);

  const { surveyFormData, setSurveyFormData } = useContext(FormContext);

  useEffect(() => {
    setSurveyFormData({
      ...surveyFormData,
      ...{ "response[value]": btnValue }
    });
  }, [btnValue]);

  const handleBtnPress = event => {
    event.preventDefault();
    setBtnValue(event.target.dataset.value);
  };
  return (
    <div
      className="btn-group"
      style={{
        display: "flex",
        alignItems: "center",
        justifyContent: "center"
      }}
    >
      {Array.from({ length: survey.counter_max || 5 }, (_, i) => i + 1).map(
        i => {
          return (
            <button
              key={i}
              className={`rating-btn ${(btnValue == i) ? 'selected' : ''}`}
              style={{ width: `${100 / survey.counter_max}%` }}
              data-value={i}
              onClick={handleBtnPress}
            >
              {i}
            </button>
          );
        }
      )}
    </div>
  );
}
