class ArtistPortfolioWork < ApplicationRecord
  CATEGORIES = %w[drawing painting composition].freeze

  belongs_to :artist_membership_application
  has_many_attached :media

  validates :category, inclusion: { in: CATEGORIES }
  validates :title, presence: true
end
