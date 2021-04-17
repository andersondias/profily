json.extract! profile, :id, :first_name, :last_name, :headline, :country, :location, :created_at, :updated_at
json.url profile_url(profile, format: :json)
