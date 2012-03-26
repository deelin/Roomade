class ApartmentPhoto < ActiveRecord::Base
  has_attached_file :photo, 
    :storage => :s3,
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
    :s3_protocol => 'http',
    :url => ':s3_domain_url',
    :path => 'apartments/photos/:id/:style.:extension',
    :styles => {:thumb => "220x163#"},
    :default_url => "/images/apartment.png"
    
  validates_attachment_content_type :photo, :content_type => ['image/gif', 'image/jpg', 'image/jpeg', 'image/png'], :if => Proc.new { |imports| !imports.photo_file_name.blank? }
  validates_attachment_size :photo, :less_than => 1.megabyte, :if => Proc.new { |imports| !imports.photo_file_name.blank? }
  
  belongs_to :apartment
end
