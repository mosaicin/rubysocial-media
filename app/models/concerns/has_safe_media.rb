module HasSafeMedia
  extend ActiveSupport::Concern

  MAX_FILES = 10
  MAX_IMAGE_SIZE = 15.megabytes
  MAX_AUDIO_SIZE = 100.megabytes
  MAX_VIDEO_SIZE = 250.megabytes
  ALLOWED_CONTENT_TYPES = %w[
    image/jpeg image/png image/gif image/webp
    video/mp4 video/webm video/quicktime
    audio/mpeg audio/ogg audio/wav audio/x-wav audio/mp4
  ].freeze

  included do
    has_many_attached :media
    validate :validate_media_attachments
  end

  def media_payload
    media.map do |attachment|
      {
        id: attachment.id,
        filename: attachment.filename.to_s,
        content_type: attachment.content_type,
        byte_size: attachment.byte_size,
        url: Rails.application.routes.url_helpers.rails_blob_path(attachment, only_path: true)
      }
    end
  end

  def as_json(options = {})
    super(options).merge('media' => media_payload)
  end

  private

  def validate_media_attachments
    return if media.blank?

    errors.add(:media, "можно прикрепить не более #{MAX_FILES} файлов") if media.length > MAX_FILES

    media.each do |attachment|
      content_type = attachment.content_type.to_s
      unless ALLOWED_CONTENT_TYPES.include?(content_type)
        errors.add(:media, "тип #{content_type.presence || 'неизвестный'} не поддерживается")
      end

      limit = if content_type.start_with?('image/')
                MAX_IMAGE_SIZE
              elsif content_type.start_with?('video/')
                MAX_VIDEO_SIZE
              else
                MAX_AUDIO_SIZE
              end
      errors.add(:media, "файл #{attachment.filename} превышает допустимый размер") if attachment.byte_size > limit
    end
  end
end
