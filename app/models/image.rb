class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true, optional: true
  belongs_to :user, optional: true
  mount_uploader :picture, PictureUploader
  validate :picture_size

  private
  def picture_size
    if picture.size > Settings.picture_max_size.megabytes
      errors.add :picture, I18n.t("errors.picture_size")
    end
  end
end
