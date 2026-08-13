class ArtistReview < ApplicationRecord
  CATEGORIES = %w[drawing painting composition].freeze

  belongs_to :artist_membership_application

  validates :reviewer_name, :comment, presence: true
  validates :category, inclusion: { in: CATEGORIES }
  validates :score, inclusion: { in: 1..10 }
end
