# frozen_string_literal: true

class Relationship < ApplicationRecord
  # follower
  belongs_to :follower, class_name: "User"
  validates :follower_id, presence: true

  # followed
  belongs_to :followed, class_name: "User"
  validates :followed_id, presence: true
end
