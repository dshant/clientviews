class Response < ApplicationRecord
  belongs_to :survey
  has_rich_text :message
  has_one :video_asset, dependent: :destroy
  has_one_attached :video_feedback_data, service: :amazon, dependent: :destroy
  has_many :replies

  acts_as_taggable_on :tags

  # validates :value, presence: true

  # def replies
  #   [Struct.new(:from, :message, :source, :created_at).new(User.first, 'Some message', 'userveys', 2.hours.ago), Struct.new(:from, :message, :source, :created_at).new(OpenStruct.new(email: self.email), 'Awesome cool reply', 'visitor', 1.hours.ago)]
  # end
end
