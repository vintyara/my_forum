module MyForum
  class Attachment < Image
    belongs_to :user, class_name: 'MyForum::User'
    belongs_to :post, class_name: 'MyForum::Post'

    UPLOAD_PATH = File.join(Rails.public_path, 'uploads', 'attachments')
    URL  = File.join('/uploads', 'attachments')

    ALLOWED_FILE_EXTENSIONS   = %w(.jpg .jpeg .png .gif)
    ALLOWED_FILE_CONTENT_TYPE = %w(image/jpeg image/png image/gif)
  end
end
