class User < ActiveRecord::Base
  include User::Search

  extend FriendlyId

  friendly_id :byline, use: :slugged

  mount_uploader :avatar, AvatarUploader

  devise :database_authenticatable, :recoverable, :validatable, :rememberable,
         :timeoutable, authentication_keys: [:login], remember_for: 30.days

  attr_accessor :login

  symbolize :role

  validates :username,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }

  validates :byline, presence: true

  has_many :posts, foreign_key: :author_id

  scope :authors, ->{ where(role: [:superuser, :admin, :editor, :contributor]) }

  scope :by_name, ->{ order("LOWER(users.first_name) ASC") }

  scope :with_post_count, ->{
    select("users.*, " +
      "(SELECT COUNT(*) FROM posts WHERE posts.author_id = users.id) AS post_count"
    )
  }

  before_validation :derive_byline

  after_initialize :init

  after_update :expire_posts

  def admin_access?
    role.in?([:superuser, :admin, :editor, :contributor])
  end

  def admin?
    role == :admin
  end

  def superuser?
    role == :superuser
  end

  def editor?
    role == :editor
  end

  def admin_or_editor?
    admin? || editor?
  end

  def self.role_names(opts={})
    _names = {}

    if opts[:superuser]
      _names['Superuser'] = :superuser
    end

    _names.merge!(
      'Admin' => :admin,
      'Editor' => :editor,
      'Contributor' => :contributor,
      'Normal User' => :user
    )


    _names
  end

  def full_name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    else
      email
    end
  end

  def pretty_name
    if byline.present?
      byline
    else
      full_name
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  private

  def derive_byline
    if byline.blank?
      self.byline = username
    end
  end

  def init
    self.role = :anonymous if role.nil?
  end

  def should_generate_new_friendly_id?
    byline_changed?
  end

  # because post pages reference this info,
  # we want to make sure they get expired
  def expire_posts
    if slug_changed?
      posts.update_all({updated_at: Time.now.to_datetime})
    end
  end
  true
end

