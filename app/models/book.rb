class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :read, inclusion: { in: [true, false] }
  belongs_to :user
end
