class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :login
  
  # Allow login with email or username (devise)
  attr_accessor :login
  has_attached_file :photo, 
    :storage => :s3,
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml'),
    :s3_protocol => 'http',
    :url => ':s3_domain_url',
    :path => 'users/profile_photos/:id/:style.:extension',
    :styles => {:thumb => "100x100#"},
    :default_url => "/images/user.png"
  
  validates_attachment_content_type :photo, :content_type => ['image/gif', 'image/jpg', 'image/jpeg', 'image/png'], :if => Proc.new { |imports| !imports.photo_file_name.blank? }
  validates_attachment_size :photo, :less_than => 1.megabyte, :if => Proc.new { |imports| !imports.photo_file_name.blank? }
  
  has_many :reviews
  
  # Protected method for logging in with email or username (devise)
  protected
    def self.find_for_database_authentication(warden_conditions)
     conditions = warden_conditions.dup
     login = conditions.delete(:login)
     where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
    end
end
