class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  validates_presence_of :file
  mount_uploader :file, FileUploader
end
