class User < ActiveRecord::Base
	belongs_to :house

	def name_to_call
		'@' + handle if handle || name
	end
#	validates :house_id, presence: true
end
