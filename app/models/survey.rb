class Survey < ApplicationRecord
  has_rich_text :content
  belongs_to :account
  belongs_to :site, optional: true

  has_many :visitor_events, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :visits, dependent: :destroy
  has_many :zaps, dependent: :destroy

  has_many :survey_trigger_urls, inverse_of: :survey, dependent: :destroy
  accepts_nested_attributes_for :survey_trigger_urls, reject_if: :all_blank, allow_destroy: true

  has_many :survey_notification_emails, inverse_of: :survey, dependent: :destroy
  accepts_nested_attributes_for :survey_notification_emails, reject_if: :all_blank, allow_destroy: true

  has_one_attached :avatar, dependent: :destroy

  has_many :webhooks, class_name: 'SurveyResponseWebhook', dependent: :destroy

  def visitors
    VisitorIdentity.where(visitor_token: visits.pluck(:visitor_token).uniq)
  end

  def image(options = {})
    hash = Digest::MD5.hexdigest(account&.users&.first&.email&.downcase || '')
    options.reverse_merge!(default: :mp, rating: :pg, size: 144)
    "https://secure.gravatar.com/avatar/#{hash}.png?#{options.to_param}"
  end

  def eligible_for_show?
    case trigger_type
    when 'manual'
      {trigger: 'manual'}
    when 'delay'
      {
        trigger: 'delay',
        delay: delay_time_number.send(delay_time_interval)
      }
    when 'url'
      {
        trigger: 'url',
        delay: delay_time_number.send(delay_time_interval)
      }
    end
  end
end
