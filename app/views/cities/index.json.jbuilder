json.array!(@cities) do |city|
  json.extract! city, :id, :name, :status, :state
  json.url city_url(city, format: :json)
end
