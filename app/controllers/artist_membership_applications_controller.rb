class ArtistMembershipApplicationsController < ApplicationController
  def new
    @application = ArtistMembershipApplication.new
  end

  def create
    @application = ArtistMembershipApplication.new(application_params)

    ArtistMembershipApplication.transaction do
      @application.save!
      ArtistMembershipApplication::CATEGORIES.each do |category|
        work = @application.portfolio_works.create!(work_params(category))
        work.media.attach(params.dig(:works, category, :media)) if params.dig(:works, category, :media).present?
      end
      @application.submit!
    end

    redirect_to club_application_path, notice: 'Заявка отправлена на рассмотрение комиссии.'
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  private

  def application_params
    params.require(:artist_membership_application).permit(
      :applicant_email,
      :display_name,
      :statement,
      education_documents: []
    )
  end

  def work_params(category)
    params.require(:works).require(category).permit(:title, :technique, :year_created, :author_note)
  end
end
