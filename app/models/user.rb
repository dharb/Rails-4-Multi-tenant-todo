class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :validatable, :rememberable

  belongs_to :company
  validates :email, presence: true
  validates :name, presence: true
  validates :company_id, presence: true
  validates :auth_token, uniqueness: true
  before_create :generate_authentication_token!

  has_many :tasks, dependent: :destroy

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token

    end while self.class.exists?(auth_token: auth_token)
  end
end
