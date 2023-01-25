module ApplicationHelper
  include Pagy::Frontend
  def flash_messages
    capture do
      flash.each do |key, value|
        concat tag.div(
          data: {
            controller: :flash, flash_key_value: key, flash_msg_value: value
          }
        )
      end
    end
  end

  def grav_img(email, options = {})
    hash = Digest::MD5.hexdigest(email&.downcase || '')
    options.reverse_merge!(default: :mp, rating: :pg, size: 144)
    "https://secure.gravatar.com/avatar/#{hash}.png?#{options.to_param}"
  end

end
