import React, {useState, useContext} from "react";
import { FormContext } from './Modal'
import {debounce} from 'lodash-es';

export function Email() {
  const {surveyFormData, setSurveyFormData} = useContext(FormContext)

  const handleChange = e => {
    setSurveyFormData({...surveyFormData,...{'response[email]': e.target.value}})
  }

  return (
    <div className="form-group" style={{display: 'flex', alignItems: 'center', justifyContent: 'center'}}>
      <input
        className="form-field"
        style={{
          color: '#495057',
          backgroundColor: '#fff',
          backgroundClip:' padding-box',
          border: '1px solid #ced4da',
          borderRadius: '.25rem',
          transition: 'border-color .15s ease-in-out,box-shadow .15s ease-in-out'
        }}
        type="text"
        onChange={debounce(handleChange, 200)}
        name="response[email]"
        placeholder="Enter your email (optional)"
        />
    </div>
  )
}
