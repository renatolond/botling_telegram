class User < ActiveRecord::Base
	belongs_to :house

	validates :house_id, presence: true
end
