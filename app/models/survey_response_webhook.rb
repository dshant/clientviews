class SurveyResponseWebhook < ApplicationRecord
  belongs_to :survey

  validates_presence_of :name, :url
  validates :url, format: { with: /\A((http|https):\/\/)/, message: "must be a valid web URL with http or https" }
end
