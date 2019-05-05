class UserActivity < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  attribute :start, :datetime, default: "2000-01-01"

  validates :user_id, uniqueness: { scope: :activity_id,
    message: "Error" }

   has_many :actuser_photo, dependent: :destroy
end
