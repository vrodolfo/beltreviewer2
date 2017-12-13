class Event < ActiveRecord::Base
  belongs_to :user

  has_many :attendees

  has_many :users_attending, through: :attendees, source: :user
  has_many :comments


   validates :name, :location, :state, :presence => true,length: { minimum: 2, maximum:100 }
   validates :date, :presence => true

end
