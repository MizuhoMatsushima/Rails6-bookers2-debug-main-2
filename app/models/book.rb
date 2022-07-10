class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :post_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  #星の評価
  #validates :evaluation, presence: true
  #validates :evaluation, numericality: {
    # only_integer: true,
  #  less_than_or_equal_to: 5,
  #  greater_than_or_equal_to: 1,
  #}


  #PV数の計測
  is_impressionable

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } # 今日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } # 前日
  scope :created_2days, -> { where(created_at: 2.days.ago.all_day) }
  scope :created_3days, -> { where(created_at: 3.days.ago.all_day) }
  scope :created_4days, -> { where(created_at: 4.days.ago.all_day) }
  scope :created_5days, -> { where(created_at: 5.days.ago.all_day) }
  scope :created_6days, -> { where(created_at: 6.days.ago.all_day) }
  scope :created_this_week, -> { where(created_at: (Time.current - 6.day).at_beginning_of_day...(Time.current).at_end_of_day) }  # 今週
  scope :created_last_week, -> { where(created_at: (Time.current - 13.day).at_beginning_of_day...(Time.current - 7.day).at_end_of_day) } # 前週

  #参考：下記記述でも可能
  #scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } #今週
  #scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) } # 前週

  #1週間のグラフ作成
  #scope :created_days_ago, ->(n) { where(created_at: n.days.ago.all_day) }

  def self.past_week_count
   (1..6).map { |n| created_days_ago(n).count }.reverse
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

end
