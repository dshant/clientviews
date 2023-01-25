import React, { useContext } from 'react';
import VideoRecorder from 'react-video-recorder';
import styled from 'styled-components';
import { FormContext } from './Modal';
import { Email } from './Email';
import { Footer } from './Footer';

const CaptureWrapper = styled.div`
  margin: 10px 5px;

  & svg {
    display: none;
  }
`;

export const VideoCapture = ({survey, handleSubmit}) => {
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
    <>
      <CaptureWrapper>
        <VideoRecorder
          timeLimit={(survey.video_limit * 1000)}
          showReplayControls
          replayVideoAutoplayAndLoopOff={false}
          onRecordingComplete={(videoBlob) => {
            handleVideoRecording(videoBlob);
          }}
        />
      </CaptureWrapper>
      {survey.email_collect && (
        <div className="collect__email">
          <Email />
        </div>
      )}
      <Footer handleSubmit={handleSubmit} />
      </>
  );
};
