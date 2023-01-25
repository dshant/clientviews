class Visit < ApplicationRecord
  belongs_to :survey, optional: true
  belongs_to :visitor_identity, foreign_key: 'visitor_token', primary_key: 'visitor_token', optional: true

  include PgSearch::Model

  pg_search_scope :visit_search, associated_against: {
    visitor_identity: [:email, :extra_attributes]
  }, using: {tsearch: { prefix: true, any_word: true } }
end
