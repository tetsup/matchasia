class Teacher < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable
  has_many :lessons, dependent: :destroy
  has_many :reservations, through: :lessons
  has_many :feedbacks, through: :lessons
  has_many :reports, through: :lessons
  has_one_attached :photo
  belongs_to_active_hash :language

  validates :username,
    presence: true,
    length: { in: 3..20 },
    format: { with: /\A[a-zA-Z][a-zA-Z0-9]+\z/ },
    uniqueness: true
  validates :about, length: { maximum: 200 }

  after_save do
    # 本当はemail_changed?を使いたいが、before_saveだと保存失敗した場合でもZoom案内届いてしまう
    # そこで、create_zoom_user側で、teacherの更新があるたびに既存かどうか判定するが、API呼び出し回数は増える
    create_zoom_user if confirmed?
  end

  def password_required?
    super if confirmed?
  end

  def zoom_user_available?
    Zoom.new.user_email_check(email: email)['existed_email']
  end

  def create_zoom_user
    return false if zoom_user_available?

    Zoom.new.user_create(action: 'create', type: 1, email: email)
    true
  rescue Zoom::Error => e
    logger.error e.message
    AdminMailer.failed_to_add_zoom_user(self)
  end

  def zoom_user_id
    return nil unless zoom_user_available?

    Zoom.new.user_get(id: email)['id']
  end
end
