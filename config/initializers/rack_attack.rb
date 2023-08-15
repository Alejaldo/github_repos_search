class Rack::Attack
  throttle('req/ip', limit: 5, period: 1.minute, &:ip) # Throttle by IP

  # Throttle POST requests to /search
  throttle('search/ip', limit: 5, period: 1.minute) do |req|
    req.ip if req.path == '/search' && req.post?
  end
end
