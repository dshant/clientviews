class Reply < ApplicationRecord
  belongs_to :response
  has_one :video_asset, dependent: :destroy
  has_one_attached :video_response, service: :amazon, dependent: :destroy

  def from
    user = User.find_by(id: self[:from]) if is_uuid?(self[:from])
    return user if user

    Struct.new(:email).new(self[:from])
  end

  private

  def is_uuid?(str)
    str.is_a?(String) &&
      str.match?(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/)
  end
end
