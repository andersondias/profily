class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.string :first_name, limit: 60, null: false
      t.string :last_name, limit: 60, null: false
      t.string :headline, limit: 200, null: false
      t.string :country, limit: 60, null: false
      t.string :location, limit: 100, null: false
      t.string :slug, limit: 100, null: false, unique: true

      t.timestamps
    end
  end
end
