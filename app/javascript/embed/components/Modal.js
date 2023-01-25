import React, { useState, useEffect } from "react";
import { isNull, isEmpty } from "lodash-es";
import styled from "styled-components";
import { Content } from "./Content";
import { formPost } from "../helpers";

export const FormContext = React.createContext({});

const BackSpan = styled.span`
  margin: 5px 10px;
  cursor: pointer;
`;

export function Modal(props) {
  const [survey, setSurvey] = useState({});
  const [previewParams, setPreviewParams] = useState({});
  const [surveyFormData, setSurveyFormData] = useState({ _choice: null });
  const [display, setDisplay] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [isError, setIsError] = useState(false);

  const { scriptSrc, visitorId, preview, id: surveyId } = props;

  const setChoice = (val) => {
    if (
      surveyFormData?._choice == "videoUpload" ||
      surveyFormData?._choice == "videoCapture"
    ) {
      val = "video";
    }
    setSurveyFormData({
      ...surveyFormData,
      ...{ _choice: val },
    });
  };

  const handleBtnPress = (event) => {
    event.preventDefault();
    setBtnValue(event.target.dataset.value);
  };

  useEffect(() => {
    // subscribe event
    window.addEventListener(`survey.${surveyId}.display`, handleDisplay);
    window.addEventListener(`survey.${surveyId}.hide`, handleHideDisplay);
    window.addEventListener(`survey.${surveyId}.preview`, handlePreview);
    return () => {
      // unsubscribe event
      window.removeEventListener(`survey.${surveyId}.display`, handleDisplay);
      window.removeEventListener(`survey.${surveyId}.hide`, handleHideDisplay);
      window.removeEventListener(`survey.${surveyId}.preview`, handlePreview);
    };
  }, []);

  useEffect(() => {
    const fetchData = async () => {
      setIsError(false);
      setIsLoading(true);

      let url = `${scriptSrc}/api/v1/surveys/${surveyId}?visitorId=${visitorId}`;
      let method = "GET";
      let headers = { accept: "application/json" };
      let options = { method, headers };

      if (preview) {
        const csrfToken = document.querySelector("[name='csrf-token']");
        const body = JSON.stringify(previewParams);
        url = `${scriptSrc}/surveys/${surveyId}/preview`;
        method = `POST`;
        headers = {
          "Content-type": "application/json",
          accept: "application/json",
          "X-CSRF-Token": csrfToken?.content || null,
        };
        options = { method, headers, body };
      }

      try {
        const result = await fetch(url, options);
        const data = await result.json();
        setSurvey(data);
      } catch (error) {
        setIsError(true);
      }

      setIsLoading(false);
    };

    fetchData();
  }, [surveyId, previewParams]);

  useEffect(() => {
    if (survey?.enabled_to_show?.type == "delay") {
      setTimeout(handleDisplay(), survey?.enabled_to_show?.delay_s || 5000);
    } else if (survey?.enabled_to_show?.type == "url") {
      if (survey?.enabled_to_show?.show) {
        setTimeout(() => handleDisplay(), 5000);
      }
    }
  }, [survey]);

  const handleDisplay = (e) => {
    setDisplay(true);
  };

  const handleHideDisplay = (e) => {
    setDisplay(false);
  };

  const handlePreview = (e) => {
    setPreviewParams(e.detail.params);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (preview) {
      setSurveyFormData({ _choice: "thanks" });
      return;
    }
    formPost(survey, surveyFormData, setSurveyFormData);
  };

  if (isLoading) {
    return <span>Loading</span>;
  }
  if (Object.keys(survey).length == 0) {
    return null;
  }

  let containerClass = `${survey.position == "modal" ? "" : survey.position}`;
  if (preview) {
    containerClass = "preview";
  }

  let borderStyle = {
    borderTop: "#1da1f2 5px solid",
  };

  if (survey.border_color) {
    borderStyle = {
      borderTop: `${survey.border_color} 5px solid`,
    };
  }

  return (
    <FormContext.Provider value={{ surveyFormData, setSurveyFormData }}>
      <div
        className={`mbox micromodal-slide ${display ? "is-open" : ""}`}
        id={`modal-${survey.id}`}
        aria-hidden="true"
      >
        <div
          className={survey.position == "modal" ? "modal__overlay" : ""}
          tabIndex="-1"
          data-micromodal-close
        >
          <div
            className={`modal__container ${containerClass}`}
            role="dialog"
            aria-modal="true"
            aria-labelledby="modal-1-title"
            style={borderStyle}
          >
            <header className="modal__header">
              {!isEmpty(surveyFormData) && !isNull(surveyFormData?._choice) && (
                <BackSpan onClick={() => setChoice(null)}> ← Back</BackSpan>
              )}
              <button
                className="mbox__close"
                aria-label="Close modal"
                onClick={() => setDisplay(false)}
              />
            </header>
            <div className="modal_wrapper">
              <Content
                survey={survey}
                _choice={surveyFormData._choice}
                handleSubmit={handleSubmit}
                handleHideDisplay={handleHideDisplay}
              />
            </div>
            <div className="powered">
              Powered by{" "}
              <a href="https://userveys.com/?utm_source=userveys&utm_medium=powered_by_link&utm_campaign=Powered%20By%20Link">
                Userveys
              </a>
            </div>
          </div>
        </div>
      </div>
    </FormContext.Provider>
  );
}
