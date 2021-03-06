# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         authentication_keys: [:login], omniauth_providers: %i[github]
  validates_format_of :username, with: /^[a-zA-Z0-9_\.\-]*$/, multiline: true
  has_one_attached :avatar

  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :books, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :comments, dependent: :destroy

  attr_accessor :login

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def feed(book_or_report)
    book_or_report.where("user_id IN (#{following_ids_subquery})
                     OR user_id = :user_id", user_id: id)
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.name
      image_url = auth.info.image
      uri = URI.parse(image_url)
      image = uri.open
      user.avatar.attach(io: image, filename: "#{user.username}_profile.png")
    end
  end

  private
    def following_ids_subquery
      "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    end
end
