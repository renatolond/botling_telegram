class Schema < ActiveRecord::Migration
	def change
		create_table :users, force: true do |t|
			t.string :name
			t.string :handle
		end
	end
end
