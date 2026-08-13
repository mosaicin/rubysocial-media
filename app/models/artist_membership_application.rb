class ArtistMembershipApplication < ApplicationRecord
  CATEGORIES = %w[drawing painting composition].freeze
  STATUSES = %w[draft submitted in_review approved declined appealed].freeze

  has_many :portfolio_works, dependent: :destroy
  has_many :artist_reviews, dependent: :destroy

  has_many_attached :education_documents
  has_many_attached :private_materials

  validates :applicant_email, :display_name, presence: true
  validates :status, inclusion: { in: STATUSES }
  validate :portfolio_has_required_categories, if: :submitted?

  def submitted?
    %w[submitted in_review approved declined appealed].include?(status)
  end

  def submit!
    update!(status: 'submitted', submitted_at: Time.current)
  end

  private

  def portfolio_has_required_categories
    missing = CATEGORIES - portfolio_works.map(&:category).uniq
    errors.add(:portfolio_works, "нужны работы по разделам: #{missing.join(', ')}") if missing.any?
  end
end
