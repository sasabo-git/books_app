# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         authentication_keys: [:login], omniauth_providers: %i[github]
  validate :validate_username
  has_one_attached :avatar

  # following（ユーザーがフォローしている人）との関連付け
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy # ユーザーを削除したらリレーションシップも同時に削除
  has_many :following, through: :active_relationships, source: :followed
  # followerとの関連付け
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy # ユーザーを削除したらリレーションシップも同時に削除
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :books, dependent: :destroy

  attr_writer :login

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def login
    @login || self.username || self.email
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # 自分とフォローしている人のBooksを返す
  def feed_books
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Book.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
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
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
end
