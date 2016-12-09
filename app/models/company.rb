class Company < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :tasks
  validates :name, presence: true
  validates :subdomain, presence: true, format: { with: /\A[a-zA-Z0-9]+\Z/ }

end
