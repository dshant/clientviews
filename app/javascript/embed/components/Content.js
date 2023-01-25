import React, { useState, useEffect, useContext } from "react";
import { isNull } from "lodash-es";
import styled from "styled-components";
import { Email } from "./Email";
import { Rating } from "./Rating";
import { Scale } from "./Scale";
import { Freeform } from "./Freeform";
import { VideoChoice } from "./VideoChoice";
import { FormContext } from "./Modal";
import { Thanks } from "./Thanks";
import { Footer } from "./Footer";

const RatingWithText = ({ survey }) => {
  return (
    <>
      <Rating survey={survey} />
      <Freeform survey={survey} value={"extra_text"} />
    </>
  );
};

const ScaleWithText = ({ survey }) => {
  return (
    <>
      <Scale survey={survey} />
      <Freeform survey={survey} value={"extra_text"} />
    </>
  );
};

export const ChoiceWrapper = styled.div`
  height: 150px;
  display: flex;
  align-items: center;
  justify-content: center;

  & button.modal__btn {
    margin: 0 10px !important;
  }
`;

const BackSpan = styled.span`
  margin: 5px 10px;
  cursor: pointer;
`;

export function Content({ survey, _choice, handleSubmit, handleHideDisplay }) {
  const [choice, setChoice] = useState(null);
  const { surveyFormData, setSurveyFormData } = useContext(FormContext);
  const components = {
    rating: Rating,
    scale: Scale,
    rating_w_text: RatingWithText,
    scale_w_text: ScaleWithText,
    freeform: Freeform,
  };

  const handleSetChoice = (event, choice) => {
    event.preventDefault();
    setSurveyFormData({
      ...surveyFormData,
      ...{ _choice: choice },
    });
  };

  const TagName = components[survey.survey_type];
  return (
    <main className="modal__content" id="modal-1-content">
      {isNull(_choice) && (
        <>
          <div id="top_content">
            {!survey.hide_image && (
              <img
                src={survey.avatar}
                style={{ height: "144px", width: "144px" }}
              />
            )}
            <strong className="person">{survey.person_name}</strong>
          </div>
          <p id="body">
            <span dangerouslySetInnerHTML={{ __html: survey.body }} />
          </p>
          <form
            name={`survey_${survey.id}`}
            action={survey.action}
            method="post"
            data-survey-vide-upload-url={survey.du_url}
            data-survey-video-token={survey.video_token}
          >
            <div className="survey__content">
              {isNull(_choice) && survey.video_feedback_enabled && (
                <>
                  <h5 className="text-center">Reply With:</h5>
                  <ChoiceWrapper>
                    <button
                      className="modal__btn modal__btn-primary"
                      onClick={(e) => handleSetChoice(e, "video")}
                    >
                      <div style={{ marginBottom: "5px" }}>
                        <svg
                          aria-hidden="true"
                          focusable="false"
                          data-prefix="fa-thin"
                          data-icon="camcorder"
                          className="svg-inline--fa fa-camcorder fa-w-18"
                          role="img"
                          xmlns="http://www.w3.org/2000/svg"
                          viewBox="0 0 576 512"
                        >
                          <path
                            d="M320 160H64V104C64 73.125 89.125 48 120 48H312C316.422 48 320 44.422 320 40S316.422 32 312 32H120C80.297 32 48 64.297 48 104V162.264C20.443 169.4 0 194.213 0 224V416C0 451.346 28.654 480 64 480H320C355.348 480 384 451.346 384 416V224C384 188.654 355.348 160 320 160ZM368 416C368 442.467 346.467 464 320 464H64C37.533 464 16 442.467 16 416V224C16 197.533 37.533 176 64 176H320C346.467 176 368 197.533 368 224V416ZM555.656 164.484C542.906 157.75 527.5 158.625 515.688 166.734L419.563 230.547C415.906 233 414.906 237.969 417.344 241.641C419.781 245.344 424.75 246.281 428.438 243.891L524.656 180C531.781 175.141 540.531 174.609 548.219 178.641C555.594 182.531 560 189.734 560 197.922V441.984C560 450.188 555.594 457.406 548.219 461.281C540.594 465.328 531.719 464.781 524.531 459.828L428.406 396.094C424.781 393.687 419.781 394.641 417.344 398.344C414.906 402.031 415.906 406.984 419.594 409.437L515.594 473.094C522.188 477.625 529.844 479.937 537.563 479.937C543.75 479.937 549.969 478.437 555.656 475.437C568.406 468.75 576 456.234 576 441.984V197.922C576 183.688 568.406 171.188 555.656 164.484ZM312 240H72C67.578 240 64 243.578 64 248S67.578 256 72 256H312C316.422 256 320 252.422 320 248S316.422 240 312 240Z"
                            fill="currentColor"
                          />
                        </svg>
                      </div>
                      Video
                    </button>
                    <button
                      className="modal__btn modal__btn-primary"
                      onClick={(e) => handleSetChoice(e, "text")}
                    >
                      <div style={{ marginBottom: "5px" }}>
                        <svg
                          aria-hidden="true"
                          focusable="false"
                          data-prefix="fa-thin"
                          data-icon="comment-text"
                          className="svg-inline--fa fa-comment-text fa-w-16"
                          role="img"
                          xmlns="http://www.w3.org/2000/svg"
                          viewBox="0 0 512 512"
                        >
                          <path
                            d="M344.001 175.999H168.001C163.594 175.999 160.001 179.593 160.001 183.999S163.594 191.999 168.001 191.999H248V327.999C248 332.405 251.594 335.999 256 335.999S264 332.405 264 327.999V191.999H344.001C348.407 191.999 352.001 188.405 352.001 183.999S348.407 175.999 344.001 175.999ZM256 31.999C114.594 31.999 0 125.093 0 239.999C0 289.593 21.406 334.999 57 370.702C44.5 421.093 2.687 465.999 2.187 466.499C0 468.796 -0.594 472.202 0.687 475.202C2 478.202 4.812 479.999 8 479.999C74.313 479.999 124 448.202 148.594 428.593C181.312 440.905 217.594 447.999 256 447.999C397.406 447.999 512 354.905 512 239.999S397.406 31.999 256 31.999ZM256 431.999C220.879 431.999 186.641 425.815 154.23 413.616L145.723 410.417L138.617 416.085C118.418 432.186 78.477 458.116 25.957 463.139C40.395 444.846 63.375 411.46 72.531 374.553L74.703 365.796L68.332 359.405C34.098 325.065 16 283.772 16 239.999C16 134.132 123.664 47.999 256 47.999S496 134.132 496 239.999S388.336 431.999 256 431.999Z"
                            fill="currentColor"
                          />
                        </svg>
                      </div>
                      Text
                    </button>
                  </ChoiceWrapper>
                </>
              )}
            </div>
          </form>
        </>
      )}
      {!isNull(_choice) &&
        _choice.startsWith("video") &&
        survey.video_feedback_enabled && (
          <VideoChoice
            survey={survey}
            handleSubmit={handleSubmit}
            handleSetChoice={handleSetChoice}
            choice={_choice}
          />
        )}
      {((!isNull(_choice) &&
        _choice == "text" &&
        survey.video_feedback_enabled) ||
        (isNull(_choice) && !survey.video_feedback_enabled)) && (
        <>
          {survey.survey_type && <TagName survey={survey} />}
          {survey.email_collect && (
            <div className="collect__email">
              <Email />
            </div>
          )}
          <Footer handleSubmit={handleSubmit} />
        </>
      )}
      {!isNull(_choice) && _choice == "thanks" && <Thanks survey={survey} />}
    </main>
  );
}

// <%= render survey_type_component.new(survey: survey) unless survey_type_component.nil? %>
