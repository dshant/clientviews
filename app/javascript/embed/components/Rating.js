import React, {useEffect, useState, useContext} from "react";
import { FormContext } from './Modal'

export function Rating({ survey }) {
  const [btnValue, setBtnValue] = useState(null)

  const {surveyFormData, setSurveyFormData} = useContext(FormContext)

  useEffect(() => {
    setSurveyFormData({...surveyFormData, ...{'response[value]': btnValue}})
  }, [btnValue])

  const handleBtnPress = (event) => {
    setBtnValue(event.target.dataset.value)
  }
  const ratingIcon = survey.rating_icon == 'stars' ? 'star' : '#x2661'
  return (
    <div className="rating" style={{display: 'flex', alignItems: 'center', justifyContent: 'center'}}>
      {Array.from({length: 5}, (_, i) => i + 1).map((i)=> {
        return (
          <span onClick={handleBtnPress} key={i} dangerouslySetInnerHTML={{__html: `&${ratingIcon};`}}  className={`rating-btn ${(btnValue && (i <= btnValue)) ? 'selected' : ''} ${survey.rating_icon.slice(0, -1)}`} data-value={i}></span>
        )

      })
      }
    </div>
  )
}
