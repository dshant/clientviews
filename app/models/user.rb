class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :slack]
  belongs_to :account

  def self.from_omniauth(access_token, plan)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(
        name: data['name'],
        account: Account.create(name: "Google - #{data['email']}"),
        email: data['email'],
        password: Devise.friendly_token[0, 20]
      )
      Billable.update_stripe(plan, user, user.account)
    end
    user
  end

  def grav(options = {})
    hash = Digest::MD5.hexdigest(email.downcase || '')
    options.reverse_merge!(default: :mp, rating: :pg, size: 144)
    "https://secure.gravatar.com/avatar/#{hash}.png?#{options.to_param}"
  end

  def generate_jwt
    JWT.encode({ id: id,
                exp: 60.days.from_now.to_i },
               Rails.application.secrets.secret_key_base)
  end
end
