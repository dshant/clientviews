import React, { useState, useContext } from "react";
import { FileChecksum } from "../vendor/FileChecksum.js";
import { isNull } from "lodash-es";

import yoha from "../embed/yoha";

export const formPost = async (survey, surveyFormData, setSurveyFormData) => {
  console.log(survey, surveyFormData);
  const data = new FormData();
  const visitorId = yoha.getVisitorId();
  surveyFormData = await handleVideoData(survey, data, surveyFormData);
  Object.keys(surveyFormData).forEach((key) => {
    if (!key.startsWith("_")) {
      data.append(key, surveyFormData[key]);
    }
  });
  if (!isNull(visitorId)) {
    data.append("visitor_id", visitorId);
  }
  console.log(...data);
  fetch(survey.action, {
    method: "POST",
    body: data,
  })
    .then((response) => {
      if (response.ok) {
        if (response.redirected) {
          window.location.href = response.url;
        } else {
          setSurveyFormData({ _choice: "thanks" });
          setTimeout(() => window.Userveys.hide(survey.id), 10000);
        }
      }
      return Promise.reject(response);
    })
    .then((data) => {
      console.log(data);
    })
    .catch((error) => {
      console.warn(error);
    });
};

const handleVideoData = (survey, data, surveyFormData, setSurveyFormData) =>
  new Promise(async (resolve, reject) => {
    const videoToAppend = surveyFormData["response[video_feedback_data]"];
    if (videoToAppend != null) {
      const url = survey.du_url;
      const token = survey.video_token;

      const blob = await directUploadPost(
        url,
        videoToAppend,
        token,
        "Response#video_feedback_data"
      );
      const servicePutResponse = await servicePut(
        blob.direct_upload,
        videoToAppend
      );
      surveyFormData = await appendBlob(blob, data, surveyFormData);
    }
    resolve(surveyFormData);
  });

const directUploadPost = async (
  url,
  file,
  direct_upload_token,
  attachment_name
) => {
  const checksum = await createChecksum(file);
  console.log("c", checksum);
  const resp = await fetch(url, {
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      blob: {
        filename: file.name,
        content_type: file.type,
        byte_size: file.size,
        direct_upload_token,
        attachment_name,
        checksum,
      },
    }),
  });
  const data = await resp.json();
  return data;
};

const servicePut = async (directUploadResponse, file) => {
  const resp = await fetch(directUploadResponse.url, {
    method: "PUT",
    headers: directUploadResponse.headers,
    body: file,
  });
  const status = await resp.status;
  return status == 200 ? "success" : "failure";
};

const createChecksum = (file) =>
  new Promise((resolve, reject) => {
    FileChecksum.create(file, (error, checksum) => {
      if (error) reject(error);
      else resolve(checksum);
    });
  });

const appendBlob = (blob, data, surveyFormData) =>
  new Promise((resolve, reject) => {
    surveyFormData = {
      ...surveyFormData,
      ...{ "response[video_feedback_data]": blob.signed_id },
    };
    resolve(surveyFormData);
  });
