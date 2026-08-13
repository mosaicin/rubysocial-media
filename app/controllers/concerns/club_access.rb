module ClubAccess
  extend ActiveSupport::Concern

  included do
    helper_method :club_member?
  end

  private

  def require_club_member
    return if club_member?

    redirect_to club_application_path, alert: 'Доступ в закрытый клуб выдаётся после проверки заявки.'
  end

  def club_member?
    %w[verified_artist reviewer moderator admin].include?(session[:club_role].to_s)
  end
end
