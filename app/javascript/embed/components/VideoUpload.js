import React, { useContext, useState, useCallback } from 'react';
import { isEmpty } from 'lodash-es';
import styled from 'styled-components';
import { useDropzone } from 'react-dropzone';
import { Email } from './Email';
import { Footer } from './Footer';
import { FormContext } from './Modal';

const RemoveButton = styled.button`
  color: red;

  &:hover {
    background: transparent;
    box-shadow: none;
  }
`

const getColor = (props) => {
  if (props.isDragAccept) {
    return '#00e676';
  }
  if (props.isDragReject) {
    return '#ff1744';
  }
  if (props.isDragActive) {
    return '#2196f3';
  }
  return '#eeeeee';
};

const Container = styled.div`
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  margin: 20px 0;
  padding: 20px;
  border-width: 2px;
  border-radius: 2px;
  border-color: ${(props) => getColor(props)};
  border-style: dashed;
  background-color: #fafafa;
  color: #bdbdbd;
  outline: none;
  transition: border 0.24s ease-in-out;
`;

export const VideoUpload = ({ survey, handleSubmit }) => {
  const [myFile, setMyFile] = useState(null);
  const { surveyFormData, setSurveyFormData } = useContext(FormContext);

  const onDrop = useCallback(
    (acceptedFiles) => {
      setMyFile(acceptedFiles[0]);
      setSurveyFormData({
        ...surveyFormData,
        ...{ 'response[video_feedback_data]': acceptedFiles[0] },
      });
    },
    [myFile],
  );


  const {
    acceptedFiles,
    getRootProps,
    getInputProps,
    isDragActive,
    isDragAccept,
    isDragReject,
  } = useDropzone({
    onDrop,
    accept: 'video/*',
    maxFiles: 1,
  });

  const removeFile = (file) => () => {
    console.log(file);
    setMyFile(null);
    const newState = surveyFormData
    delete newState['response[video_feedback_data]']
    setSurveyFormData(newState);
  };


  return (
    <>
      <section className="container">
        <Container {...getRootProps({ isDragActive, isDragAccept, isDragReject })}>
          <input {...getInputProps()} />
          <p>Drag and drop a video file here, or click to select a file</p>
        </Container>
        {!isEmpty(myFile) && <ul style={{margin: '20px 0'}}><li key={myFile.path}>
          {myFile.path}
          {' '}
          -
          {myFile.size}
          {' '}
          bytes
          <RemoveButton className="btn" onClick={removeFile(myFile)}>X</RemoveButton>
        </li></ul>}
      </section>
      {survey.email_collect && (
        <div className="collect__email">
          <Email />
        </div>
      )}
      <Footer handleSubmit={handleSubmit} />
    </>
  );
};
