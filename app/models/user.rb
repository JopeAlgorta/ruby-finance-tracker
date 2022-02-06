class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.search_friends search_string
    search_string.strip!
    @friends = (search_by('first_name', search_string) + search_by('last_name', search_string) + search_by('email', search_string)).uniq
  end

  def is_tracking? ticker
    stock = Stock.check_db ticker
    return false unless stock

    stocks.where(id: stock.id).exists?
  end

  def reach_maximum?
    stocks.count < 10
  end

  def can_track? ticker
    reach_maximum? and not is_tracking? ticker
  end

  def full_name
    if first_name.nil? and last_name.nil?
      return email.split('@')[0]
    end
    "#{first_name || ""} #{last_name || ""}"
  end

  def friend_of friend
    friends.include? friend
  end

  private

  def self.search_by field, param
    User.where("lower(#{field}) like ?", "%#{param.downcase}%")
  end
end
