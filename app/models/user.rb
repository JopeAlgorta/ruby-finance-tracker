class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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
end
