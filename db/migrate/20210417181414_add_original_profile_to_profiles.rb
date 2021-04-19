class AddOriginalProfileToProfiles < ActiveRecord::Migration[6.1]
  def change
    add_reference(:profiles, :original_profile, foreign_key: { to_table: :profiles })
  end
end
