import React, { useEffect, useState, useContext } from "react";
import { FormContext } from "./Modal";
import { debounce } from "lodash-es";

export function Freeform({ survey, value = "value" }) {
  const { surveyFormData, setSurveyFormData } = useContext(FormContext);

  const handleChange = (e) => {
    setSurveyFormData({
      ...surveyFormData,
      ...{ [`response[${value}]`]: e.target.value },
    });
  };

  return (
    <div className="form-group">
      <span>Type your feedback below:</span>
      <textarea
        className="form-field"
        name="response[value]"
        rows="4"
        onChange={debounce(handleChange, 200)}
      ></textarea>
    </div>
  );
}
