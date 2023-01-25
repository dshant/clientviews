import React, { useContext } from 'react';
import { isNull } from 'lodash-es';
import styled from 'styled-components';

import { FormContext } from './Modal';
import { VideoCapture } from './VideoCapture';
import { VideoUpload } from './VideoUpload';
import { ChoiceWrapper } from './Content';

const VideoChoiceWrapper = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-between;
  height: 240px;

  & button {
    width: 90px;
    height: 100px;
  }
`;

export const VideoChoice = ({
  survey, choice, handleSubmit, handleSetChoice,
}) => {
  const { surveyFormData, setSurveyFormData } = useContext(FormContext);

  const handleVideoRecording = (videoBlob) => {
    videoBlob.name = 'video';
    // Do something with the video...
    setSurveyFormData({
      ...surveyFormData,
      ...{ 'response[video_feedback_data]': videoBlob },
    });
    console.log('videoBlob', videoBlob);
  };
  return (
    <div className="survey__content">
      {!isNull(choice) && choice == 'video' && survey.video_feedback_enabled && (
        <VideoChoiceWrapper>
          <button
            className="modal__btn modal__btn-primary"
            onClick={(e) => handleSetChoice(e, 'videoCapture')}
          >
            <svg
              style={{ width: '44px' }}
              aria-hidden="true"
              focusable="false"
              data-prefix="fa-thin"
              data-icon="video"
              className="svg-inline--fa fa-video fa-w-18"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 576 512"
            >
              <path
                d="M336 64H48C21.492 64 0 85.49 0 112V400C0 426.51 21.492 448 48 448H336C362.508 448 384 426.51 384 400V112C384 85.49 362.508 64 336 64ZM368 400C368 417.645 353.645 432 336 432H48C30.355 432 16 417.645 16 400V112C16 94.355 30.355 80 48 80H336C353.645 80 368 94.355 368 112V400ZM555.656 100.484C542.906 93.75 527.5 94.625 515.688 102.734L419.563 166.547C415.906 169 414.906 173.969 417.344 177.641C419.781 181.344 424.75 182.281 428.438 179.891L524.656 116C531.781 111.141 540.531 110.609 548.219 114.641C555.594 118.531 560 125.734 560 133.922V377.984C560 386.188 555.594 393.406 548.219 397.281C540.594 401.328 531.719 400.781 524.531 395.828L428.406 332.094C424.781 329.687 419.781 330.641 417.344 334.344C414.906 338.031 415.906 342.984 419.594 345.437L515.594 409.094C522.188 413.625 529.844 415.937 537.562 415.937C543.75 415.937 549.969 414.437 555.656 411.437C568.406 404.75 576 392.234 576 377.984V133.922C576 119.688 568.406 107.188 555.656 100.484Z"
                fill="currentColor"
              />
            </svg>
            Record
          </button>
          <span>or</span>
          <button
            className="modal__btn modal__btn-primary"
            onClick={(e) => handleSetChoice(e, 'videoUpload')}
          >
            <div style={{ marginBottom: '5px' }}>
              <svg
                style={{ width: '44px' }}
                aria-hidden="true"
                focusable="false"
                data-prefix="fa-thin"
                data-icon="file-video"
                className="svg-inline--fa fa-file-video fa-w-12"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 384 512"
              >
                <path
                  d="M374.629 150.625L233.371 9.375C227.371 3.371 219.23 0 210.746 0H64C28.652 0 0 28.652 0 64V448C0 483.344 28.652 512 64 512H320C355.348 512 384 483.344 384 448V173.254C384 164.766 380.629 156.629 374.629 150.625ZM224 22.629L361.375 160H248C234.781 160 224 149.234 224 136V22.629ZM368 448C368 474.469 346.469 496 320 496H64C37.531 496 16 474.469 16 448V64C16 37.531 37.531 16 64 16H208V136C208 158.062 225.938 176 248 176H368V448ZM240 288C240 270.328 225.674 256 208 256H112C94.326 256 80 270.328 80 288V384C80 401.672 94.326 416 112 416H208C225.674 416 240 401.672 240 384V375.641L278.688 397.781C281.312 399.25 284.188 400 287.062 400C289.999 400 292.938 399.219 295.594 397.688C300.844 394.625 304 389.156 304 383.062V288.938C304 282.813 300.844 277.344 295.562 274.281C290.25 271.219 283.938 271.188 278.687 274.25L240 296.363V288ZM224 384C224 392.824 216.822 400 208 400H112C103.178 400 96 392.824 96 384V288C96 279.176 103.178 272 112 272H208C216.822 272 224 279.176 224 288V384ZM288 288.938L286.625 383.875L240 357.227V314.855L288 288.938Z"
                  fill="currentColor"
                />
              </svg>
            </div>
            Upload
          </button>
        </VideoChoiceWrapper>
      )}
      {!isNull(choice) && choice == 'videoCapture' && survey.video_feedback_enabled && (
        <VideoCapture survey={survey} handleSubmit={handleSubmit} />
      )}
      {!isNull(choice) && choice == 'videoUpload' && survey.video_feedback_enabled && (
        <VideoUpload survey={survey} handleSubmit={handleSubmit} />
      )}
    </div>
  );
};
