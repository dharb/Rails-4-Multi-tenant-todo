class Task < ActiveRecord::Base
  validates :title, :user_id, :company_id, presence: true
  belongs_to :user
  belongs_to :company
  
  before_validation(on: :create) do
    self.company_id = user.company_id if user.present?
  end
end
