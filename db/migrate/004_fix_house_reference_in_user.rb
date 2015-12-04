class FixHouseReferenceInUser < ActiveRecord::Migration
	def change
		remove_reference :users, :houses, index:true
		add_reference :users, :house, index: true
	end
end
