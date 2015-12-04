class AddHouseTableAndReferences < ActiveRecord::Migration
	def change
		create_table :houses do |t|
			t.string :name

			t.timestamps null: true
		end

		change_table :users do |t|
			t.timestamps null: true
		end

		add_reference :users, :houses, index: true
		add_foreign_key :users, :houses
	end
end
