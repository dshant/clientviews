class VisitorIdentity < ApplicationRecord
  has_many :visits, foreign_key: 'visitor_token', primary_key: 'visitor_token'
  has_many :events, class_name: 'VisitorEvent', foreign_key: 'visitor_token', primary_key: 'visitor_token'
end
