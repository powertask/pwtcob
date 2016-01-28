BoletoSimples.configure do |c|
  c.environment = :production
  c.application_id = ENV['BOLETOSIMPLES_APP_ID']
  c.application_secret = ENV['BOLETOSIMPLES_APP_SECRET']
  c.access_token = ENV['BOLETOSIMPLES_ACCESS_TOKEN']
end
