class Site < ApplicationRecord
  belongs_to :account

  # has_many :site_survey_memberships
  has_many :surveys

  def self.by_url(url)
    uri = URI.parse(url)
    domain = uri.host
    domain += ":#{uri.port}" unless [80, 443].include?(uri.port)

    find_by(domain: domain)
  end
end
