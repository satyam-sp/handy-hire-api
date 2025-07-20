Geocoder.configure(
  timeout: 5,
  lookup: :nominatim, # or :google, :mapbox, etc.
  units: :km,
  language: :en,
  http_headers: { "User-Agent" => "MyApp" }
)